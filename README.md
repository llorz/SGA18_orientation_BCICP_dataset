# Datasets
Here are the datasets tested in the paper "Continuous and Orientation-preserving Correspondence via Functinal Maps" by Jing Ren, Adrien Poulenard, Peter Wonka and Maks Ovsjanikov.

Original Datasets can be found at:
- FAUST: http://faust.is.tue.mpg.de/
- TOSCA: http://tosca.cs.technion.ac.il/book/resources_data.html

In our setting, we remeshed each shape independently using [LRVD algorithm](https://ieeexplore.ieee.org/document/6832586/?arnumber=6832586) to avoid overfitting. The remeshed meshes have ~5k vertices.

For each of the dataset (FAUST/TOSCA_Isometric/TOSCA_nonIsometric)
- **test_pairs.txt**: each row shows a pair of shape names in this collection that we tested
- **vtx_5k/**: 
  - **xxx.off**: the remeshed shapes in this collection
  - **corres/**: for any pair (A.off, B.off) in this collection, "A.vts" stores the given **ground-truth** *direct* correspondence to "B.vtx", and "A.sym.vts" stores the **ground-truth** *symmetric* correspondence to "B.vtx"
  - **segmentation/**: for a pair (A.off, B.off), the segmentation of the two shapes are stored as "A_B.A.seg.sym" and "A_B.B.seg.sym". Moreover, "A_B.B.seg.nonsym" and "A_B.B.seg.nonsym" give the segmentation after breaking the symmetry. Please refer to [Robust Structure-based Shape Correspondence](https://github.com/hexygen/structure-aware-correspondence) for the details of the segmentation
  - **maps/**: stores the maps we computed and measured for the curves shown in the paper (with format "A_B.map", and the pairs are listed in the "test_pairs.txt")
    - **BIM/**:  [Blended Intrinsic Maps](http://www.vovakim.com/projects/CorrsBlended/) (note that the maps are **0-based**)
    - **PMF_hk/**: [Kernel Matching](https://github.com/zorah/KernelMatching) (note that the maps are computed on some samples of the mesh, and there are `NaN` indicating no correspondences)
    - **WKSini_direct/**: using WKS desriptors with our orientation-preserving term
    - **WKSini_symm/**: using WKS descriptors with out orientation-reversing term
    - **WKSini_direct_BCICP/**: WKSini_direct + BCICP
    - **WKSini_symm_BCICP/**: WKSini_symm + BCICP
    - **SEGini_direct_BCICP/**: using segmentations to compute the descriptors, then add the orientation-preserving operator to compute the initial functional map. Then add BCICP refinement. 
  

Comments
---------
- The script `run_example.m` shows how to load the **ground-truth correspondences**, pre-computed **segmentation**, and saved **maps**. It is also included that how we measured the pre-vectex accuracy of the maps. 
- Our baselines are (1) BIM, (2) WKSini + ICP and (3) PMF. (2) is not included here, but the maps can be easilty computed by applying 10 iterations of ICP to "WKSini_direct" and "WKSini_symm".
- Measuring these maps on **all** the given correspondence should give the curves shown in the paper. 
- The released code is optimized a bit, and it will give better maps than the ones stored here.
- Please do not forget to cite the paper [LRVD algorithm](https://ieeexplore.ieee.org/document/6832586/?arnumber=6832586) if you use the dataset in your work. Thanks (〃ﾉωﾉ)
