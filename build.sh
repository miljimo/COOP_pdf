#!/bin/bash
PROGRAM_NAME="COOPDocument"
EXTENSION_OUTPUT=pdf
FILENAME="${PROGRAM_NAME}.${EXTENSION_OUTPUT}"
OUTPUT_DIRECTORY=./bin
SOURCE_DIR=./src
ENTRY_FILE_NAME=${SOURCE_DIR}/main.tex
OUTPUT_FORMAT_COMMAND="-output-format=${EXTENSION_OUTPUT}"
OUTPUT_DIR_COMMAND="-output-directory=${OUTPUT_DIRECTORY}" 
INTERATION_MOD_COMMAND="-interaction=nonstopmode"
COMPILER_XX_FLAGS="${OUTPUT_FORMAT_COMMAND} ${OUTPUT_DIR_COMMAND} ${INTERATION_MOD_COMMAND}"
OUTPUT_FILENAME="${OUTPUT_DIRECTORY}/${FILENAME}"
DOCUMENTS_DIR=./documents
PACKAGE_DIR=./packages

function install_packages(){
  # tlmgr option repository ctan
  #https://www.tug.org/texlive/doc/tlmgr.html#DESCRIPTION
  # Install tlmgr - the native tex live manager
  # to install the package needed for this project.
  local filename="$1"
  if [ -e $filename ] ; then
    #update the tlmgr tool and its packages.
    $(tlmgr --usermode --usertree=$PACKAGE_DIR update --self)
    $(tlmgr --usermode --usertree=$PACKAGE_DIR update --all);

    if [ -d "${PACKAGE_DIR}" ] ; then
      mkdir -p "${PACKAGE_DIR}"
    fi

    #load the installation required packages for the project.
    while read -e line
      do
       line="${line## }"
       line="${line%% }"
       if [[ $line != "" ]]; then
         echo $line
         tlmgr --usermode --usertree=./packages install $line
       fi
      done < ${filename};
  fi
}

function build(){
if [ -e "${OUTPUT_FILENAME}" ] ; then
  echo "Deleting ${OUTPUT_FILENAME}"
  rm -f ${OUTPUT_FILENAME}
fi
 local compile_result=$(pdftex  ${COMPILER_XX_FLAGS} -jobname=${PROGRAM_NAME}  ${ENTRY_FILE_NAME}) 

 if [ -e "${OUTPUT_FILENAME}" ] ; then
   echo "Coping output file=[${OUTPUT_FILENAME}] to ${DOCUMENTS_DIR}/${FILENAME}"
   cp "${OUTPUT_FILENAME}" "${DOCUMENTS_DIR}/${FILENAME}"
 else
   echo "Tex Document Compilation Process Failed"
 fi

}


install_packages  requirements
build 
