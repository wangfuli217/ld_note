TEMPLATE = app

DESTDIR = $$PWD/../bin
INCLUDEPATH += $$PWD/../include

CONFIG(debug,debug|release){
    TARGET = the_app_debug
}else{
    TARGET = the_app
}

win32-msvc*{
    QMAKE_CXXFLAGS += /std:c++latest
}else{
    CONFIG += c++17
    LIBS += -lstdc++fs
}

NEW_MOC_HEADERS =         $${PWD}/test2.hpp $${PWD}/test1.hpp
new_moc.input =           NEW_MOC_HEADERS
new_moc.dependency_type = TYPE_C
new_moc.variable_out =    SOURCES
new_moc.output  =         moc_new_${QMAKE_FILE_BASE}.cpp

CONFIG(debug,debug|release){

new_moc.commands = $${DESTDIR}/new_moc_debug ${QMAKE_FILE_NAME} ${QMAKE_FILE_OUT}
QMAKE_EXTRA_COMPILERS += new_moc

isEmpty(QMAKE_PRE_LINK){
    QMAKE_PRE_LINK+= $${DESTDIR}/before_link_debug $${PWD}
}else{
    QMAKE_PRE_LINK+= $$escape_expand(\\n\\t)$${DESTDIR}/before_link_debug $${PWD}
}

isEmpty(QMAKE_POST_LINK){
    QMAKE_POST_LINK+=$${DESTDIR}/after_link_debug $${PWD}
}else{
    QMAKE_POST_LINK+=$$escape_expand(\\n\\t)$${DESTDIR}/after_link_debug $${PWD}
}

}else{

new_moc.commands = $${DESTDIR}/new_moc ${QMAKE_FILE_NAME} ${QMAKE_FILE_OUT}
QMAKE_EXTRA_COMPILERS += new_moc

isEmpty(QMAKE_PRE_LINK){
    QMAKE_PRE_LINK+= $${DESTDIR}/before_link $${PWD}
}else{
    QMAKE_PRE_LINK+= $$escape_expand(\\n\\t)$${DESTDIR}/before_link $${PWD}
}

isEmpty(QMAKE_POST_LINK){
    QMAKE_POST_LINK+=$${DESTDIR}/after_link $${PWD}
}else{
    QMAKE_POST_LINK+=$$escape_expand(\\n\\t)$${DESTDIR}/after_link $${PWD}
}

}

export(QMAKE_PRE_LINK)
export(QMAKE_POST_LINK)
export(QMAKE_EXTRA_COMPILERS)

SOURCES += $$PWD/main.cpp


#/*endl_input_of_latex_for_clanguage_lick*/
#$$escape_expand(\\n\\t)
