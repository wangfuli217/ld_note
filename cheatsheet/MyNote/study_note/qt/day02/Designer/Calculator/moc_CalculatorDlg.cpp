/****************************************************************************
** Meta object code from reading C++ file 'CalculatorDlg.h'
**
** Created: Mon Aug 3 14:31:25 2015
**      by: The Qt Meta Object Compiler version 63 (Qt 4.8.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "CalculatorDlg.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'CalculatorDlg.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_CalculatorDlg[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       2,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      15,   14,   14,   14, 0x08,
      34,   14,   14,   14, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_CalculatorDlg[] = {
    "CalculatorDlg\0\0enableCalcButton()\0"
    "calcClicked()\0"
};

void CalculatorDlg::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        CalculatorDlg *_t = static_cast<CalculatorDlg *>(_o);
        switch (_id) {
        case 0: _t->enableCalcButton(); break;
        case 1: _t->calcClicked(); break;
        default: ;
        }
    }
    Q_UNUSED(_a);
}

const QMetaObjectExtraData CalculatorDlg::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject CalculatorDlg::staticMetaObject = {
    { &QDialog::staticMetaObject, qt_meta_stringdata_CalculatorDlg,
      qt_meta_data_CalculatorDlg, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &CalculatorDlg::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *CalculatorDlg::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *CalculatorDlg::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_CalculatorDlg))
        return static_cast<void*>(const_cast< CalculatorDlg*>(this));
    if (!strcmp(_clname, "Ui::CalculatorDlg"))
        return static_cast< Ui::CalculatorDlg*>(const_cast< CalculatorDlg*>(this));
    return QDialog::qt_metacast(_clname);
}

int CalculatorDlg::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QDialog::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 2)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
