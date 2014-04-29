MOC=C:\qt\4.1.4\bin\moc.exe
UIC=C:\qt\4.1.4\bin\uic.exe
# remove the -v if you want it to be quiet
QT_MOC_UI=E:\NAADSM\Interface-HEAD\remoteDB\qt-moc-ui.pl -v

all-before: qt_moc_ui $(patsubst %.cpp,%.o,$(wildcard moc_*.cpp)) moclib.a

qt_moc_ui:
	$(QT_MOC_UI) $(MOC) $(UIC)

moc_%.o: moc_%.cpp
	$(CPP) -c $< -o $@ $(CXXFLAGS)		

moclib.a: $(patsubst %.cpp,%.o,$(wildcard moc_*.cpp))
	ar cq moclib.a $(wildcard moc_*.o) 

# you may not want/need this:
clean-custom:
	${RM} moc_*.cpp
	${RM} ui_*.h
	${RM} moclib.a

