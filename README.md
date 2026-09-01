# Molecular Biology II

This repository supports the *Molecular Biology II* course at AU. 

Find links to the ChIP-seq exercise below.

| Version | PDF | ipynb | Colab | JupyterLite |
|---------|-----|-------|-------|-------------|
| Exercise | [PDF](build/exercise/chip_seq_2026.pdf) | [ipynb](build/exercise/chip_seq_2026.ipynb) | [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/au-mbg/molecular-biology-II/blob/main/build/exercise/chip_seq_2026.ipynb) | [Open in JupyterLite](https://au-mbg.github.io/jupyterlite-playground/lab/index.html?fromURL=https://raw.githubusercontent.com/au-mbg/molecular-biology-II/refs/heads/main/build/exercise/chip_seq_2026.ipynb) |
| Solution | [PDF](build/solution/chip_seq_2026.pdf) | [ipynb](build/solution/chip_seq_2026.ipynb) | [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/au-mbg/molecular-biology-II/blob/main/build/solution/chip_seq_2026.ipynb) | [Open in JupyterLite](https://au-mbg.github.io/jupyterlite-playground/lab/index.html?fromURL=https://raw.githubusercontent.com/au-mbg/molecular-biology-II/refs/heads/main/build/solution/chip_seq_2026.ipynb) |

## Editing 

The exercise can be edited by changing the [chip_seq_2026.qmd](quarto/chip_seq_2026.qmd) file. 
This is a Quarto markdown file that is the source for both `.PDF` and `.ipynb` outputs - for both the 
student and the solution versions. 

To render new versions of the PDF and notebooks the following command should be run 

```
pixi r build
```

And the produced files should be pushed to the GitHub remote repository. 
See https://au-mbg.github.io/course-materials-handbook/ for more information regarding 
`pixi`, `quarto` and `git`. 

## `course-utils` 

`course-utils` is a small supporting Python package that is installed by one of the first 
cells of the notebook. 

This package is distributed as a wheel meaning that if the package is changed a new wheel needs to be built. To do so run 

```
pixi r build-wheel
```

If you change the version of the package, in [pyproject.toml](course-utils/pyproject.toml), then you must also update the version number specified in [chip_seq_2026.qmd](quarto/chip_seq_2026.qmd). 

## Pyodide 

In addition to the solution-checking function `course-utils` also provides a shim that makes the exercise
compatible with Pyodide, see [_pyodide.py](course-utils/src/course_utils/_pyodide.py). 

This makes `pd.read_csv` compatible with reading files given a web address in Pyodide/jupyterlite. 
