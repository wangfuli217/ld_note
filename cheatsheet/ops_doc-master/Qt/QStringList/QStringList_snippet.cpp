
1. [append(), operator+=() or operator<<()]
    QStringList fonts;
    fonts.append( "Times" );
    fonts += "Courier";
    fonts += "Courier New";
    fonts << "Helvetica [Cronyx]" << "Helvetica [Adobe]";

2. [iterator]
    for ( QStringList::Iterator it = fonts.begin(); it != fonts.end(); ++it ) {
        cout << *it << ":";
    }
    cout << endl;
    // Output:
    //  Times:Courier:Courier New:Helvetica [Cronyx]:Helvetica [Adobe]:
3. [concatenate]
    QString allFonts = fonts.join( ", " );
    cout << allFonts << endl;
    // Output:
    //  Times, Courier, Courier New, Helvetica [Cronyx], Helvetica [Adobe]
4. [sort]
    fonts.sort();
    cout << fonts.join( ", " ) << endl;
    // Output:
    //  Courier, Courier New, Helvetica [Adobe], Helvetica [Cronyx], Times

    QStringList helveticas = fonts.grep( "Helvetica" );
    cout << helveticas.join( ", " ) << endl;
    // Output:
    //  Helvetica [Adobe], Helvetica [Cronyx]
5.[split]
    QString s = "Red\tGreen\tBlue";
    QStringList colors = QStringList::split( "\t", s );
    cout << colors.join( ", " ) << endl;
    // Output:
    //  Red, Green, Blue
    


