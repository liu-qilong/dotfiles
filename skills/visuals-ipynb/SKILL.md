---
name: visuals-ipynb
description: Create or revise configurable visualization notebooks, including PyVista mesh and point-cloud rendering and Matplotlib scientific figures, with inline previews and exported figures.
---

# Visualization notebooks

Put input paths, example selection, colors, sampling counts, camera settings, spacing, resolution, and export switches in the first configuration cell. Preserve the user's existing choices when revising a notebook. Keep data loading, rendering helpers, and example figures in separate cells so changing appearance does not repeat inference or expensive geometry preparation.

Use PyVista for 3D meshes and point clouds; use Matplotlib for scientific plots and 2D analysis. Display figures inline. Set `EXPORT = True` to save figures beneath `<notebook directory>/output/<notebook name>/`. For example, `notebook/visuals/shapes.ipynb` exports to `notebook/visuals/output/shapes/`. Configure the notebook name and directory explicitly; notebooks do not reliably provide `__file__`.

Keep generated outputs out of model checkpoints and benchmark input directories. Changing a notebook's export path does not imply permission to move its input artifacts. When moving authorized existing exports, inspect collisions, preserve distinct versions, and verify the moved files.

## Environment and PyVista setup

Use the project's existing `uv` environment and Jupyter kernel. In a repository with a managed environment, run checks with `uv run python ...` or its `.venv/bin/python`; do not switch to a system interpreter or a different project's environment. PyVista rendering needs `pyvista` and `pillow`; notebook construction/execution typically uses `nbformat`, `nbclient`, and `ipykernel`. Declare missing dependencies through the project's existing dependency workflow. Rendering exported meshes normally needs no CUDA or model imports.

```python
import json
from pathlib import Path

import numpy as np
import pyvista as pv
from IPython.display import display
from PIL import Image

NOTEBOOK_NAME = "example-visualization"
NOTEBOOK_DIR = Path("notebook/visuals").resolve()  # configure relative to the kernel's working directory.
OUTPUT_DIR = NOTEBOOK_DIR / "output" / NOTEBOOK_NAME
EXPORT = True

pv.set_jupyter_backend("static")
pv.global_theme.transparent_background = True
```

Use `pv.Plotter(off_screen=True, window_size=WINDOW_SIZE)` for reproducible inline screenshots and headless execution. Close the plotter in `finally`. Obtain the image once with `plotter.screenshot(transparent_background=True, return_img=True)`, display it with Pillow, and save the same image when exporting. Keep the PNG alpha channel for flowchart assets. Do not treat a headless warning alone as proof that rendering failed; inspect the actual output. Diagnose real backend failures instead of silently changing renderers.

### Reference lighting and camera

The correspondence reference uses these settings:

```python
RENDER_CONFIGS = {
    "ambient": 0.1,
    "diffuse": 1.0,
    "specular": 0.6,
    "specular_power": 30,
    "smooth_shading": True,
}
CAMERA_POSITION = "xy"
ZOOM = 1.8
CAMERA_MARGIN = 1.3
```

Enable parallel projection for shape comparisons. Add all geometry, set the camera orientation, fit the scene, apply the configurable margin through `camera.parallel_scale`, then apply `camera.zoom(ZOOM)`. Inspect for clipped hands, feet, labels, and end shapes. The reference zoom is a starting point; long rows and different poses can need a larger margin. A directional camera such as `xy` must match the actual coordinate frame; expose deterministic display rotations when needed.

When comparing full meshes, crops, and samples of the same shape, fit every image to the complete shape's bounds. Otherwise an independently fitted crop can appear larger than the complete body. Apply presentation rotations to the mesh and its corresponding points together, without modifying saved inputs or resampling them.

For rerenderable camera metadata, save position, focal point, view-up, parallel projection, parallel scale, and view angle. Serialize explicit vectors such as `list(plotter.camera.position)`; a PyVista `CameraPosition` object is not automatically JSON serializable. Restoring saved camera state must not apply the original zoom a second time.

### Small and large image presets

Expose a preset switch and leave the dimensions easy to override:

| Figure | Small: iteration | Large: final export |
|---|---|---|
| Wide shape comparison | `(1280, 720)` | `(3840, 2160)`; reference notebook size |
| Individual shape/point asset | `(800, 800)` | `(1600, 1600)` |

```python
QUALITY = "small"  # small or large
WINDOW_SIZES = {"small": (1280, 720), "large": (3840, 2160)}
assert QUALITY in WINDOW_SIZES
WINDOW_SIZE = WINDOW_SIZES[QUALITY]
```

For standalone assets, use the square presets instead. Keep camera, geometry, sample identities, and color limits fixed between preview and final renders. Point size and label font size are in pixels; expose them separately and scale them with resolution when equivalent visual weight is intended. A useful point-cloud starting range is 3–4 pixels for an 800-pixel preview and 6–8 pixels for a 1600-pixel export, with `render_points_as_spheres=True`. Verify the result rather than assuming those values fit every scene.

## Texture UVs and correspondence direction

Reuse the exported UV coordinates. Load a textured OBJ with `pv.read()` and verify `mesh.active_texture_coordinates` exists, has one row per point, and is finite. Read its matching image with `pv.read_texture()`. When constructing `PolyData` yourself, preserve the triangle indices and assign `active_texture_coordinates` explicitly. Do not regenerate UVs independently on the recipient: doing so discards the predicted transfer.

For correspondence exports with this contract:

```python
p2p.shape == (len(shape_n["verts"]),)
p2p[n_vertex] = m_vertex
```

`shape_n` is the correspondence source and `shape_m` is its target. Texture flows the other way: `shape_m` donates UVs to `shape_n`. The reference visualization puts `shape_m` on the left and `shape_n` on the right, and names the pair `<shape_m>--<shape_n>`. Do not infer correspondence direction from the order in a printed pair label.

The reference exports use `target.obj` for textured `shape_m` and `source.obj` for textured `shape_n`. Heatmap `source.vtp` and `geodist.npz` contain errors in `shape_n` vertex order. Verify the saved metadata and geometry alignment before assigning scalar arrays. These names describe this export contract, not every external dataset; inspect other formats explicitly.

If an OBJ has faces but no UVs, stop and identify the export problem. In the observed trimesh exporter, assigning `MultiMaterial` silently dropped UVs. A single supported material works for fully textured meshes; partially rejected meshes can be exported as separate textured and gray submeshes in a scene. Validate a round trip with PyVista, not only file existence or face counts.

If UV generation is part of the requested computation, the reference projects the donor's two largest-variance coordinate axes and normalizes each projected axis to `[0, 1]`; reject degenerate spans. Direct transfer gathers donor UVs through `p2p`. Spectral smoothing should use factored spectral products rather than a dense vertex-by-vertex matrix. Rerendering an already exported transfer should not repeat either computation.

## Reference example: texture pair plus geodesic heatmap

The row below contains textured `shape_m`, textured `shape_n`, then the same `shape_n` with its own per-vertex errors. `SHAPE_SPACING` and `TEXTURE_HEATMAP_SPACING` are placement offsets in mesh units, not guaranteed surface-to-surface gaps. Make them configurable because extended arms or differing physical scales can cause overlap.

Configure these alongside the notebook/export settings above:

```python
TEXTURE_DIR = Path("path/to/texture-transfer/shape_m--shape_n")
HEATMAP_DIR = Path("path/to/geodist-heatmap/shape_m--shape_n")
TEXTURE_PATH = Path("path/to/texture-symbol-grid.png")
SHAPE_SPACING = 1.0
TEXTURE_HEATMAP_SPACING = 1.0
GEODIST_COLOR = "pink"  # pink, teal, or red
GEODIST_SCALE_MIN = None  # auto: zero
GEODIST_SCALE_MAX = None  # auto: maximum over the compared figures
SHOW_LABELS = True
SHOW_SCALAR_BAR = True
```

The loader uses the saved data without importing models:

```python
reference = pv.read(TEXTURE_DIR / "target.obj")
textured = pv.read(TEXTURE_DIR / "source.obj")
heatmap = pv.read(HEATMAP_DIR / "source.vtp")
metadata = json.loads((HEATMAP_DIR / "render.json").read_text())
assert metadata["heatmap_mesh"] == "source.vtp"
with np.load(HEATMAP_DIR / "geodist.npz", allow_pickle=False) as archive:
    errors = archive["geodist"].copy()
    counts = archive["contribution_count"].copy()
for mesh in (reference, textured):
    assert mesh.active_texture_coordinates is not None
    assert mesh.active_texture_coordinates.shape == (mesh.n_points, 2)
    assert np.isfinite(mesh.active_texture_coordinates).all()
np.testing.assert_allclose(textured.points, heatmap.points, rtol=1e-6, atol=1e-7)
np.testing.assert_array_equal(textured.faces, heatmap.faces)
assert errors.shape == counts.shape == (heatmap.n_points,)
assert not np.isinf(errors).any()
valid = np.isfinite(errors)
assert np.array_equal(valid, counts > 0)
assert valid.any(), "This pair has no evaluable geodesic errors"
assert (errors[valid] >= 0).all()
```

Use one scale for the compared figures. If the maximum is automatic across methods or resolutions, compute it from all selected finite error arrays before rendering any figure. Preserve the dataset's distance normalization and use its metadata label; registered stored distances and template-area-normalized raw-scan distances must not be relabeled as identical physical units.

```python
from matplotlib.colors import LinearSegmentedColormap, to_rgb

endpoints = {"pink": "#C2185B", "teal": "#00796B", "red": "#D32F2F"}
assert GEODIST_COLOR in endpoints
low = 0.0 if GEODIST_SCALE_MIN is None else float(GEODIST_SCALE_MIN)
high = float(errors[valid].max()) if GEODIST_SCALE_MAX is None else float(GEODIST_SCALE_MAX)
if high == low == 0 and GEODIST_SCALE_MAX is None:
    high = 1.0  # all-zero errors are valid and render white.
assert np.isfinite([low, high]).all() and 0 <= low < high
endpoint = endpoints[GEODIST_COLOR]
colors = np.full((heatmap.n_points, 3), 211, dtype=np.uint8)
weight = np.clip((errors[valid] - low) / (high - low), 0, 1)[:, None]
colors[valid] = np.rint(255 * ((1 - weight) + weight * np.asarray(to_rgb(endpoint)))).astype(np.uint8)
heatmap["rgb"] = colors

plotter = pv.Plotter(off_screen=True, window_size=WINDOW_SIZE)
try:
    texture = pv.read_texture(str(TEXTURE_PATH))
    plotter.add_mesh(reference, texture=texture, **RENDER_CONFIGS)
    plotter.add_mesh(textured.translate((SHAPE_SPACING, 0, 0), inplace=False), texture=texture, **RENDER_CONFIGS)
    heatmap_x = SHAPE_SPACING + TEXTURE_HEATMAP_SPACING
    actor = plotter.add_mesh(heatmap.translate((heatmap_x, 0, 0), inplace=False), scalars="rgb", rgb=True, show_scalar_bar=False, **RENDER_CONFIGS)
    if SHOW_LABELS:
        y = min(reference.bounds.y_min, textured.bounds.y_min) - 0.15
        positions = np.array([[reference.center[0], y, 0], [textured.center[0] + SHAPE_SPACING, y, 0], [heatmap.center[0] + heatmap_x, y, 0]])
        plotter.add_point_labels(positions, ["shape_m", "shape_n", "Geodesic error"], show_points=False, shape=None, always_visible=True, text_color="black", font_size=22)
    if SHOW_SCALAR_BAR:
        cmap = LinearSegmentedColormap.from_list("geodist", ["white", endpoint])
        actor.mapper.lookup_table = pv.LookupTable(cmap=cmap, scalar_range=(low, high))
        actor.mapper.scalar_range = (low, high)
        plotter.add_scalar_bar(title=metadata["distance_convention"], mapper=actor.mapper)
    plotter.enable_parallel_projection()
    plotter.camera_position = CAMERA_POSITION
    plotter.reset_camera()
    plotter.camera.parallel_scale *= CAMERA_MARGIN
    plotter.camera.zoom(ZOOM)
    rgba = plotter.screenshot(transparent_background=True, return_img=True)
finally:
    plotter.close()
display(Image.fromarray(rgba))
if EXPORT:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    Image.fromarray(rgba).save(OUTPUT_DIR / "texture-transfer-and-geodist.png")
```

White represents zero error with the default lower bound. Values outside explicit limits are clipped. Vertices with no measured error remain gray, not white: remeshed registered correspondence rows may cover only a subset of unique vertices. Never fill missing values or scatter the errors onto predicted target vertices unless that operation is explicitly requested. The example rejects an entirely unmeasured pair; if showing such pairs is desired, render gray and omit the scalar bar explicitly.

## Matplotlib: inline preview, PDF export

Export Matplotlib figures as **PDF**, preserving vector text, lines, and markers. Display them inline as usual; do not default to PNG export for Matplotlib. Use another format only when explicitly requested. Figure dimensions should be configurable in inches; `dpi` controls rasterized artists, not the resolution of vector paths.

```python
import matplotlib.pyplot as plt

FIGSIZE = (6.4, 3.6)
RASTER_DPI = 300
fig, ax = plt.subplots(figsize=FIGSIZE, constrained_layout=True)
# draw the requested data here.
if EXPORT:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUTPUT_DIR / "figure.pdf", format="pdf", bbox_inches="tight", transparent=True, dpi=RASTER_DPI)
plt.show()
plt.close(fig)
```

## Validate the rendered result

Execute the notebook with real selected inputs when available. Check exported file dimensions, alpha for PyVista PNGs, sample counts where applicable, and figure readability. Visually inspect at least the final representative layout: verify that textures survived loading, errors belong to the intended mesh, the color range is shared, shapes do not overlap, and limbs, labels, and legends are not clipped. Missing inputs should name the expected path and fail clearly rather than producing a plausible substitute.
