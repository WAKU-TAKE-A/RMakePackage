# R script to make package
{
	#################
	# constant var. #
	#################

	DESCRIPTION_FILE <- "_DESCRIPTION.txt"
	INDEX_FILE <- "_INDEX.csv"
	INCLUDE <- "[.]r$"
	EXCLUDE <- "^_"	
	RD_FILE <- "[.]Rd$"

	############
	# function #
	############

	b__unfactor <- function(var1)
	{
	    if(length(ncol(var1)) == 0)
	    {
	        if (is.factor(var1))
	            var1 <- levels(var1)[var1]
	    }
	    else
	    {
	        for (i in 1:ncol(var1))
	        {
	            if (is.factor(var1[, i]))
	                var1[, i] <- levels(var1[, i])[var1[, i]]
	        }
	    }

	    return(var1)
	}

	#######
	# run #
	#######

	##
	## change the current directory
	##
	ret <- T
	errMessage <- ""

	if(ret)
	{
		dirname <- dirname(sys.frame(1)$ofile)

		if(is.na(dirname))
		{
			ret <- F
			errMessage <- "It was canceled."
		}
		else
		{
			setwd(dirname)
		}
	}

	##
	## check DESCRIPTION_FILE and INDEX_FILE
	##
	if(ret)
	{
		if(!file.exists(DESCRIPTION_FILE) || !file.exists(INDEX_FILE))
		{
			ret <- F
			errMessage <- paste("Either ", DESCRIPTION_FILE, " or ", INDEX_FILE, " is not found.", sep = "")
		}
	}

	##
	## get package name
	##
	if(ret)
	{
		desc <- read.csv(DESCRIPTION_FILE, sep = ":", header = F)
		desc <- b__unfactor(desc)
		rownames(desc) <- desc[,1]
		pacName <- desc["Package", 2]
		
		if(is.null(pacName) || is.na(pacName))
		{
			ret <- F
			errMessage <- paste("The format of ", DESCRIPTION_FILE, " may be wrong.", sep = "")
		}
	}

	##
	## load functions (*.r)
	##
	if(ret)
	{
		sourceFileList <- dir(dirname)
		cond <- grep(INCLUDE, sourceFileList)

		if(length(cond) == 0)
		{
			ret <- F
			errMessage <- "R file is not found."
		}
	}

	if(ret)
	{
		sourceFileList <- sourceFileList[cond]
		cond <- grep(EXCLUDE, sourceFileList)

		if(length(cond) != 0)
			sourceFileList <- sourceFileList[-cond]

		iniObjList <- ls(envir = .GlobalEnv)

		for(vari in sourceFileList)
			source(vari)
		
		funcList <- ls(envir = .GlobalEnv)
		cond <- grep(paste(iniObjList, collapse = "|"), funcList)
		funcList <- funcList[-cond]

		cond <- sapply(funcList, function(i)
		{
			obj <- eval(parse(text = i))
			is.function(obj)
		})

		if(any(cond))
		{
			funcList <- funcList[cond]
			print("STEP1：finish loading functions.")
		}
		else
		{
			ret <- F
			errMessage <- "Can not load functions."
		}
	}

	##
	## genarate skeleton
	##
	if(ret)
	{
		retTry <- try(package.skeleton(name = pacName, list = funcList), F)
		
		if(is.null(retTry))
		{
			print("STEP2：finish generating skeleton.")
		}
		else
		{
			ret <- F
			errMessage <- retTry[1]
		}
	}

	##
	## fix NAMESPACE
	##
	if(ret)
	{
		namespace_cmd <- paste(funcList, collapse = '", "')
		namespace_cmd <- paste('export("', namespace_cmd, '")', sep = '')	
		retTry <- try(writeLines(namespace_cmd, paste(pacName, "/NAMESPACE", sep = "")), F)
		
		if(is.null(retTry))
		{
			print("STEP3：finish fixing NAMESPACE.")
		}
		else
		{
			ret <- F
			errMessage <- retTry[1]
		}
	}

	##
	## fix DESCRIPTION_FILE
	##
	if(ret)
	{
		retTry <- try(file.copy(DESCRIPTION_FILE, paste(pacName, "/DESCRIPTION", sep = ""), overwrite = T), F)
		
		if(retTry == T)
		{
			msg <- paste("STEP4：finish fixing ", DESCRIPTION_FILE, ".", sep = "")
			print(msg)
		}
		else
		{
			ret <- F
			errMessage <- retTry[1]
		}
	}

	##
	## fix Rd files and copy
	##
	FixRdFile <- function()
	{
		index <- read.csv(INDEX_FILE, header = T)
		index <- b__unfactor(index)
		man_dname <- paste(dirname, "/", pacName, "/man/",  sep = "")
		setwd(man_dname)
		
		## fix ***-package.Rd
		lst <- dir(man_dname)
		cond <- grep("-package.Rd$", lst)
		package_rd <- lst[cond]
		buf <- readLines(package_rd)
		cond <- grep("^~~", buf)
		buf <- buf[-cond]
		
		# alias
		cond <- grep("^[\\]alias", buf)
		cond <- cond[-1]

		if(length(cond) != 0)
			buf <- buf[-cond]

		#title
		cond <- which(buf == "\\title{")

		if(length(cond) != 0)
		{
			if(buf[cond + 2] == "}")
				buf[cond + 1] <- desc["Title",2]
		}

		#descrioption
		cond <- which(buf == "\\description{")

		if(length(cond) != 0)
			buf[cond + 1] <- desc["Description",2]

		#Version
		cond <- grep("^Version:", buf)

		if(length(cond) != 0)
			buf[cond] <- paste("Version: \\tab ", desc["Version",2], "\\cr")

		#License
		cond <- grep("^License:", buf)

		if(length(cond) != 0)
			buf[cond] <- paste("License: \\tab ", desc["License",2], "\\cr")

		#author
		cond <- which(buf == "\\author{")

		if(length(cond) != 0)
		{
			if(buf[cond + 4] == "}")
			{
				buf[cond + 1] <- desc["Maintainer",2]
				buf <- buf[-c(cond + 2, cond + 3)]
			}
		}

		writeLines(buf, package_rd)

		## fix title of Rd files
		for(ii in funcList)
		{
			fname <- paste(ii, ".Rd", sep = "")
			tmp <- readLines(fname)
			
			#title
			cond <- grep("^[\\]title", tmp)
			searchIndex <- match(ii, index[, "name"])
			
			if(is.na(searchIndex))
			{
				fixedTitle <- ii
			}
			else
			{
				fixedTitle <- index[searchIndex, "title"]
			}
			
			tmp[cond] <- paste("\\title{", fixedTitle, "}", sep = "")
			tmp <- tmp[c(-(cond + 1), -(cond + 2))]
			
			writeLines(tmp, con = fname)
		}

		## copy Rd files
		setwd(dirname)
		sourceFileList <- dir(dirname)
		cond <- grep(RD_FILE, sourceFileList)

		if(length(cond) != 0)
		{
			for(fn in sourceFileList[cond])
			{
				man_fn <- paste(man_dname, "/", fn, sep = "")
			
				if(file.exists(man_fn))
				{
					file.remove(man_fn)
					file.copy(fn, man_dname)
				}
			}
		}
	}

	if(ret)
	{
		retTry <- try(FixRdFile(), F)
		
		if(is.null(retTry))
		{
			print("STEP5：finish fixing Rd files.")
		}
		else
		{
			ret <- F
			errMessage <- retTry[1]
		}
	}

	##
	## check the package
	##
	if(ret)
	{
		cmd <- paste("R CMD check ", pacName, " --no-manual --no-install", sep = "")
		retTry <- try(system(cmd), F)
		
		if(retTry == 0)
		{
			print("STEP6：finish checking the package.")
		}
		else
		{
			ret <- F
			errMessage <- retTry[1]
		}
	}

	##
	## build
	##
	if(ret)
	{
		if(retTry == 0)
		{
			cmd <- paste("R CMD INSTALL --build ", pacName, sep = "")
			retTry <- try(system(cmd), F)
		}
		
		if(retTry == 0)
		{
			print("STEP7：finish build")
		}
		else
		{
			ret <- F
			errMessage <- retTry[1]
		}
	}

	##
	## finish
	##
	if(ret)
	{
		setwd(dirname)
		rm(list = ls(envir = .GlobalEnv))
	}
	else
	{
		print("Error is occured.")
		print("Content is as follows.")
		print(paste("'", errMessage, "'", sep =""))
		setwd(dirname)
		rm(list = ls(envir = .GlobalEnv))
	}
}
