##########################################################
R script to make a package

[Manual]
(1) Install "Rtools".
  (add the path of "Rtools\bin")

(2) Make sure that the following files in the same folder.
  * _DESCRIPTION.txt (DESCRIPTION_FILE)
  * _INDEX.csv (INDEX_FILE)
  * _Make_R-Package_**.r
  * r files
  * rd files (If necessary)

(3) Fix properly the following files
  * _DESCRIPTION.txt (DESCRIPTION_FILE)
  * _INDEX.csv (INDEX_FILE)
    - Don't forget the description of the package itself.
    - Start a new line in the last line.

(4) Start R  by administrator.

(5) run _MakePackage.r

###########################################################