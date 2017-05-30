winDialogTools<-function(initials=NULL,
                         types=NULL,
                         labels=NULL,
                         message="Message",
                         title="WinDialogTools()",
                         message.font=tkfont.create(size=11,weight="normal",slant="roman"),
                         tools.font=tkfont.create(size=10,weight="normal",slant="roman"),
                         labels.sep="",
                         entry.width=20,
                         max.tools=20)
{
	# User functions.
	listLength <- function(obj)
	{
		output <- NULL
		
		if(isList(obj))
		{
			buf <- summary(obj)
			output <- ifelse(is.null(nrow(buf)), 0, nrow(buf))
		}
		
		return(output)
	}
	
	isList <- function(obj)
	{
		if(is.list(obj) & !is.data.frame(obj))
		{
			return(TRUE)
		}
		else
		{
			return(FALSE)
		}
	}
	
	# Load tcltk.
	if(!is.element("package:tcltk",search())){require(tcltk)}

	# Prepare variables to manage dialog state.
	#If the window is active,done = 0
	#If the window has been closed using the OK button,done = 1
	#If the window has been closed using the Cancel button or destroyed,done = 2
	done <- tclVar(0)
	
	# Return value.
	tmp00<-NULL

	# Function to be executed when the OK button is pressed.
	cmd.ok<-function(){
		tmp00<<-lapply(1:length(types),function(vari){
			if(types[vari]=="checkbox"){
				tmp<-sapply(return.lst[[vari]],tclvalue)
				tmp2<-ifelse(tmp==1,T,F)
				return(tmp2)
			}else if(types[vari]=="numeric"){
				tmp<-as.numeric(tclvalue(return.lst[[vari]]))
				return(tmp)
			}else if(types[vari]=="character"){
				tmp<-as.character(tclvalue(return.lst[[vari]]))
				return(tmp)
			}else if(types[vari]=="logical"){
				tmp<-ifelse(tclvalue(return.lst[[vari]])=="1",T,F)
				return(tmp)
			}else if(types[vari]=="openfile_m" ||types[vari]=="openfile_s" ||types[vari]=="choosedir" ||types[vari]=="savefile"){
				tmp<-strsplit(tclvalue(return.lst[[vari]][[1]]),"[|]")
				tmp<-unlist(tmp)
				if(length(tmp)==0){tmp<-""}
				if(length(grep("[*]$",tmp))==1 && types[vari]=="openfile_m"){
					dname_strsplit<-strsplit(tmp,"[/\\]")[[1]]
					dname<-sub(paste("[",dname_strsplit[length(dname_strsplit)],"]",sep=""),"",tmp)
					tmp<-list.files(dname,full.names=T)
				}
				return(tmp)
			}else{
				tmp<-tclvalue(return.lst[[vari]])
				return(tmp)
			}
		})
		tclvalue(done)<-1
		tkdestroy(tt)
	}
	
	# Function to be executed when the CANCEL button is pressed.
	cmd.cancel<-function(){
		tmp00<<-NULL
		tclvalue(done)<-2
		tkdestroy(tt)
	}
	
	# Function to be executed when the window is closed.
	cmd.close<-function(){
		if(as.integer(tclvalue(done))==0){
			tclvalue(done)<-2
		}
	}
	
	# When cmd.getOpenFile is executed.
	cmd.getOpenFile<-function(ii,multi){
		multi<-ifelse(multi==1,T,F)
		fname<-choose.files(caption="Select file",multi=multi)
		if(length(fname)!=0 && multi==T){
			tclvalue(return.lst[[ii]][[1]])<-paste(fname,collapse="|")
			tclvalue(return.lst[[ii]][[2]])<-paste("SELECT ",length(fname),"FILES",sep="")
		}else if(!all(fname=="") && multi==F){
			tclvalue(return.lst[[ii]][[1]])<-fname
		}
	}
	
	# When cmd.chooseDir is executed.
	cmd.chooseDir<-function(ii){
		dname<-choose.dir(caption="Select directory")
		tclvalue(return.lst[[ii]][[1]])<-dname
	}
	
	# When cmd.savefile is executed.
	cmd.savefile<-function(ii){
		tclvalue(return.lst[[ii]][[1]])<-tclvalue(tkgetSaveFile(title="Choose a file name"))
	}
	
	# Usable parts.
	types.list<-c("numeric","character","logical","checkbox","combobox","radiobutton","label","openfile_m","openfile_s","choosedir","savefile")
	
	# Check
	if(!is.list(initials) | (is.list(initials) & is.data.frame(initials))){
		stop("\n'initials' are not list.")
	}
	if(!is.vector(labels) | is.list(labels)){
		stop("\n'labels' are not vector.")
	}
	if(!is.vector(types) | is.list(types)){
		stop("\n'types' are not vector.")
	}
	chk<-is.element(types,types.list)
	if(!all(chk)){
		stop(paste("\nThe format of 'types' is wrong.","Available widgets are as follows.","'numeric' 'character' 'logical' 'checkbox' 'combobox' 'radiobutton' 'label' 'openfile_m' 'openfile_s' 'choosedir' 'savefile'",sep="\n"))
	}
	chk<-listLength(initials)==length(types) & (length(types)==length(labels) | is.null(labels))
	if(chk==F){
		stop("\nThe format is wrong, the number is different.")
	}

	# Confirm the number of tabs.
	num_of_tab<-ceiling(length(types)/max.tools)
	

	# Processing to be done if 'labels' is NULL.
	if(is.null(labels)){
		labels<-as.character(1:length(types))
	}
	
	# Formatting 'labels'
	labels2<-paste(labels,labels.sep,sep="")

	# Do not display until completed.
	tclServiceMode(FALSE)
	
	# Create top level.
	if(!is.element("package:tcltk",search())){require(tcltk)}
	tt<-tktoplevel()
	tkwm.title(tt,title)
	
	# Processing to be executed in all closing events.
	tkbind(tt,"<Destroy>",cmd.close)
	
	# Create tab.
	tn <- ttknotebook(tt)
	tkpack(tn)
	for(kk in 1:num_of_tab){
		eval(parse(text=
			paste('Page',kk,'<-ttkframe(tn)',sep='')
		))
		eval(parse(text=
			paste('tkadd(tn,Page',kk,',text="Page',kk,'")',sep='')
		))
	}
	
	# Set Variables.
	frame.labels2<-list()
	frame.tools<-list()
	tools.lst<-list()
	return.lst<-list()
	labels2.lst<-list()
	
	# Placement on tab.
	for(kk in 1:num_of_tab){
	
		eval(parse(text=paste('frameOverall<-tkframe(Page',kk,')',sep='')))
		frame.msg<-tkframe(frameOverall)
		
		initial_num<-((kk-1)*max.tools+1)
		final_num<-ifelse(length(types)/max.tools>kk,max.tools*kk,length(types))
		
		for(ii in initial_num:final_num){
			frame.labels2[[ii]]<-tkframe(frameOverall)
		}#/end for ii
		
		for(ii in initial_num:final_num){
			frame.tools[[ii]]<-tkframe(frameOverall,relief="groove",borderwidth=2)
		}#/end for ii
		frame.buttons<-tkframe(frameOverall)
		
		# Label
		MSG<-tklabel(frame.msg,text=message,font=message.font)
		tkgrid(MSG,sticky="w")

		# Button
		OK.but<-tkbutton(frame.buttons,text="OK",command=cmd.ok)
		CANCEL.but<-tkbutton(frame.buttons,text="CANCEL",command=cmd.cancel)
		tkgrid(OK.but,CANCEL.but,sticky="w")

		# Label and tool
		for(ii in initial_num:final_num){
		
			labels2.lst[[ii]]<-tklabel(frame.labels2[[ii]],text=labels2[ii],font=tools.font)
			tkgrid(labels2.lst[[ii]],sticky="w")
		
		}#/end for ii

		for(ii in initial_num:final_num){
		
			if(types[ii]=="numeric"){
				
				return.lst[[ii]]<-tclVar(initials[[ii]])
				tools.lst[[ii]]<-tkentry(frame.tools[[ii]],width=entry.width,textvariable=return.lst[[ii]],font=tools.font)
				tkgrid(tools.lst[[ii]],sticky="w")
				
			}else if(types[ii]=="character"){
			
				return.lst[[ii]]<-tclVar(initials[[ii]])
				tools.lst[[ii]]<-tkentry(frame.tools[[ii]],width=entry.width,textvariable=return.lst[[ii]],font=tools.font)
				tkgrid(tools.lst[[ii]],sticky="w")
				
			}else if(types[ii]=="logical"){
			
				tools.lst[[ii]]<-list()
				tools.lst[[ii]][[1]]<-tkradiobutton(frame.tools[[ii]])
				tools.lst[[ii]][[2]]<-tkradiobutton(frame.tools[[ii]])
				return.lst[[ii]]<-tclVar(initials[[ii]])
				tkconfigure(tools.lst[[ii]][[1]],variable=return.lst[[ii]],value=TRUE)
				tkconfigure(tools.lst[[ii]][[2]],variable=return.lst[[ii]],value=FALSE)
				tkgrid(tklabel(frame.tools[[ii]],text="TRUE",font=tools.font),tools.lst[[ii]][[1]],tklabel(frame.tools[[ii]],text="FALSE",font=tools.font),tools.lst[[ii]][[2]],sticky="w")
				
			}else if(types[ii]=="checkbox"){
			
				tools.lst[[ii]]<-list()
				for(jj in 1:length(initials[[ii]])){
					tools.lst[[ii]][[jj]]<-tkcheckbutton(frame.tools[[ii]])
				}
				return.lst[[ii]]<-list()
				for(jj in 1:length(initials[[ii]])){
					return.lst[[ii]][[jj]]<-tclVar("0")
				}
				for(jj in 1:length(initials[[ii]])){
					tkconfigure(tools.lst[[ii]][[jj]],variable=return.lst[[ii]][[jj]])
				}
				for(jj in 1:length(initials[[ii]])){
					tkgrid(tklabel(frame.tools[[ii]],text=initials[[ii]][jj],font=tools.font),row=(jj-1)%/%10,column=(jj-1)%%10*2,sticky="w")
					tkgrid(tools.lst[[ii]][[jj]],row=(jj-1)%/%10,column=(jj-1)%%10*2+1,sticky="w")
				}
			
			}else if(types[ii]=="combobox"){
					
					return.lst[[ii]]<-tclVar(initials[[ii]][1])
					tools.lst[[ii]]<-ttkcombobox(frame.tools[[ii]],value=initials[[ii]],textvariable=return.lst[[ii]],font=tools.font)
					tkgrid(tools.lst[[ii]],sticky="w")
			
			}else if(types[ii]=="radiobutton"){
			
				tools.lst[[ii]]<-list()
				for(jj in 1:length(initials[[ii]])){
					tools.lst[[ii]][[jj]]<-tkradiobutton(frame.tools[[ii]])
				}
				return.lst[[ii]]<-tclVar(initials[[ii]][1])
				for(jj in 1:length(initials[[ii]])){
					tkconfigure(tools.lst[[ii]][[jj]],variable=return.lst[[ii]],value=initials[[ii]][jj])
				}
				for(jj in 1:length(initials[[ii]])){
					tkgrid(tklabel(frame.tools[[ii]],text=initials[[ii]][jj],font=tools.font),row=(jj-1)%/%10,column=(jj-1)%%10*2,sticky="w")
					tkgrid(tools.lst[[ii]][[jj]],row=(jj-1)%/%10,column=(jj-1)%%10*2+1,sticky="w")
				}
			}else if(types[ii]=="label"){
			
					frame.tools[[ii]]<-tkframe(frameOverall)
					return.lst[[ii]]<-tclVar("")
					
			}else if(types[ii]=="openfile_m"){
			
				return.lst[[ii]]<-list()
				return.lst[[ii]][[1]]<-tclVar(initials[[ii]])
				return.lst[[ii]][[2]]<-tclVar("SELECT")
				tools.lst[[ii]]<-list()
				tools.lst[[ii]][[1]]<-tkentry(frame.tools[[ii]],width=entry.width,textvariable=return.lst[[ii]][[1]],font=tools.font)
				tools.lst[[ii]][[2]]<-tkbutton(frame.tools[[ii]],text=tclvalue(return.lst[[ii]][[2]]),textvariable=return.lst[[ii]][[2]],command=eval(parse(text=paste('function() cmd.getOpenFile(',ii,',',1,')',sep=''))))
				tkgrid(tools.lst[[ii]][[1]],tools.lst[[ii]][[2]],sticky="w")
				
			}else if(types[ii]=="openfile_s"){
			
				return.lst[[ii]]<-list()
				return.lst[[ii]][[1]]<-tclVar(initials[[ii]])
				return.lst[[ii]][[2]]<-tclVar("SELECT")
				tools.lst[[ii]]<-list()
				tools.lst[[ii]][[1]]<-tkentry(frame.tools[[ii]],width=entry.width,textvariable=return.lst[[ii]][[1]],font=tools.font)
				tools.lst[[ii]][[2]]<-tkbutton(frame.tools[[ii]],text=tclvalue(return.lst[[ii]][[2]]),textvariable=return.lst[[ii]][[2]],command=eval(parse(text=paste('function() cmd.getOpenFile(',ii,',',0,')',sep=''))))
				tkgrid(tools.lst[[ii]][[1]],tools.lst[[ii]][[2]],sticky="w")
				
			}else if(types[ii]=="choosedir"){
			
				return.lst[[ii]]<-list()
				return.lst[[ii]][[1]]<-tclVar(initials[[ii]])
				return.lst[[ii]][[2]]<-tclVar("SELECT")
				tools.lst[[ii]]<-list()
				tools.lst[[ii]][[1]]<-tkentry(frame.tools[[ii]],width=entry.width,textvariable=return.lst[[ii]][[1]],font=tools.font)
				tools.lst[[ii]][[2]]<-tkbutton(frame.tools[[ii]],text=tclvalue(return.lst[[ii]][[2]]),textvariable=return.lst[[ii]][[2]],command=eval(parse(text=paste('function() cmd.chooseDir(',ii,')',sep=''))))
				tkgrid(tools.lst[[ii]][[1]],tools.lst[[ii]][[2]],sticky="w")
				
			}else if(types[ii]=="savefile"){
			
				return.lst[[ii]]<-list()
				return.lst[[ii]][[1]]<-tclVar(initials[[ii]])
				return.lst[[ii]][[2]]<-tclVar("SELECT")
				tools.lst[[ii]]<-list()
				tools.lst[[ii]][[1]]<-tkentry(frame.tools[[ii]],width=entry.width,textvariable=return.lst[[ii]][[1]],font=tools.font)
				tools.lst[[ii]][[2]]<-tkbutton(frame.tools[[ii]],text=tclvalue(return.lst[[ii]][[2]]),textvariable=return.lst[[ii]][[2]],command=eval(parse(text=paste('function() cmd.savefile(',ii,')',sep=''))))
				tkgrid(tools.lst[[ii]][[1]],tools.lst[[ii]][[2]],sticky="w")
				
			}else{
			
				stop("\nUnexpected error")
			
			}
		
		}#/end for ii
		
		if(message==""){
			tkgrid(tklabel(frameOverall,text=" ",font=tkfont.create(size=6)))
		}else{
			tkgrid(tklabel(frameOverall,text=" ",font=tkfont.create(size=6)))
			tkgrid(frame.msg,sticky="w",columnspan=2)
			tkgrid(tklabel(frameOverall,text=" ",font=tkfont.create(size=6)))
		}
		for(ii in initial_num:final_num){
			tkgrid(frame.labels2[[ii]],frame.tools[[ii]],sticky="w")
		}#end for ii		
		tkgrid(tklabel(frameOverall,text=" ",font=tkfont.create(size=6)))
		tkgrid(frame.buttons,sticky="w",columnspan=2)
		tkgrid(tklabel(frameOverall,text=" ",font=tkfont.create(size=6)))
		
		# Finish
		tkgrid(frameOverall)
	
	}#end for kk
	
	# Since it is completed, it is displayed.
	tclServiceMode(TRUE)
	tkfocus(tt)
	
	# Wait until done is not zero.
	tkwait.variable(done)
	doneVal <- as.integer(tclvalue(done))

	if(doneVal==1){
		return(tmp00)
	}else if(doneVal==2){
		return(tmp00)
	}else{
		stop("\nunexpected error")
	}
}
