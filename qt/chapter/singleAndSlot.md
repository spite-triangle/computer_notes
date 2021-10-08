
 <h1 style="font-size:60px;text-align:center;">信号与槽</h1>

# 函数

<span style="font-size:24px;font-weight:bold" class="section2">1. c函数</span>

```cpp
#include <iostream>
using namespace std;

void fcn(const string & a){
    cout << a << endl;
}

int main(int argc, char const *argv[])
{
    void (*f)(const string & a);
    f = fcn;
    f("hello world"); 
    return 0;
}

```

<span style="font-size:24px;font-weight:bold" class="section2">2. 类函数</span>

> [!tip]
> - 函数由 `&` 取地址，由`.*`或者`->*`进行调用
> - 必须要有一个对象，对函数进行调用

```cpp
#include <iostream>
using namespace std;

class Test{
public:
    void fcn(const string& a){
        cout << a << endl;
    }
};

int main(int argc, char const *argv[])
{
    void (Test::*f)(const string & a);
    Test b;
    // 使用 & 获取函数地址，Test::fcn 该类型是用于静态函数访问的
    f = &Test::fcn;
    // 必须要有一个对象来调用该函数
    (b.*f)("hello world");
    return 0;
}
```


# `connect`使用

```cpp
// 连接信号与槽
connect(信号对象,信号地址,槽对象,槽地址);

// 点击 btn_test 激活函数 helloWorld
connect(ui->btn_test,&QPushButton::clicked,this,&MainWindow::helloWorld);
```

# 自定义信号与槽

```cpp
class Student : public QObject
{
    Q_OBJECT
public:
    explicit Student(QObject *parent = nullptr);

// 定义信号
signals:

// 定义槽
public slots:

};

```

<span style="font-size:24px;font-weight:bold" class="section2">1. 自定义信号</span>

> [!tip]
> - 返回值只能是`void`
> - 只声明，不实现
> - 可以传参
> - 可以重载

<span style="font-size:24px;font-weight:bold" class="section2">2. 自定义槽</span>

> [!tip]
> - `public: ` 与 `public slots: ` 下的函数均能当槽函数使用
> - 返回值`void`
> - 需要声明，需要实现
> - 可以传参
> - 可以重载

<!--sec data-title="案例" data-id="signalAndSlot" data-show=true data-collapse=true ces-->

.h文件

```cpp
#ifndef STUDENT_H
#define STUDENT_H

#include <QObject>
#include <QMessageBox>


class Student : public QObject
{
    Q_OBJECT

private:
    QString name;
public:
    explicit Student(QObject *parent = nullptr,QString name = "");

signals:
    void requestName();

public slots:
    void sayName();
};

#endif // STUDENT_H

```

cpp 文件

```cpp
#include "student.h"

Student::Student(QObject *parent,QString name) : QObject(parent)
{
    this->name = name;
}

void Student::sayName(){
    QMessageBox message;
    message.setText(this->name);
    message.exec();
}

```

<!--endsec-->


# 触发信号

```cpp
emit 信号对象->信号();
```

> [!note|style:flat]
> **会触发所有`connect`该信号的槽。**

```cpp
MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    this->stuA = new Student(this,"mario");
    this->stuB = new Student(this,"luyig");


    connect(ui->btn_test,&QPushButton::clicked,this,&MainWindow::helloWorld);

    connect(stuA,&Student::requestName,stuB,&Student::sayName);
    connect(stuA,&Student::requestName,stuA,&Student::sayName);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::helloWorld(){
    emit stuA->requestName();
}

```

# 重载信号和槽


```cpp

#include "mainwindow.h"
#include "QPushButton"
#include "ui_mainwindow.h"


MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    this->stuA = new Student(this,"mario");
    this->stuB = new Student(this,"luyig");


    connect(ui->btn_test,&QPushButton::clicked,this,&MainWindow::helloWorld);

    // 区分重载的信号和槽
    void (Student::*sig)(QString) = &Student::requestName;
    void (Student::*slot)(QString) = &Student::sayName;
    void (Student::*sigv)() = &Student::requestName;
    void (Student::*slotv)() = &Student::sayName;

    connect(stuA,sig,stuB,slot);
    connect(stuB,sigv,stuB,slotv);

}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::helloWorld(){
    // 传参
    emit stuA->requestName("A");
    emit stuB->requestName();
}


```

> [!note|style:flat]
> - `connect`连接的信号与槽，形参要对应
> - 重载的信号和槽要靠指针函数进行区分
> - 可通过`emit`向槽传递参数

<!--sec data-title="案例" data-id="overrideSignal" data-show=true data-collapse=true ces-->

h文件

```cpp
#ifndef STUDENT_H
#define STUDENT_H

#include <QObject>
#include <QMessageBox>

class Student : public QObject
{
    Q_OBJECT

private:
    QString name;
public:
    explicit Student(QObject *parent = nullptr,QString name = "");

signals:
    void requestName();
    void requestName(QString requestor);
public slots:
    void sayName();
    void sayName(QString requestor);
};

#endif // STUDENT_H

```

cpp 文件

```cpp

#include "student.h"

Student::Student(QObject *parent,QString name) : QObject(parent)
{
    this->name = name;
}

void Student::sayName(){
    QMessageBox message;
    message.setText(this->name);
    message.exec();
}

void Student::sayName(QString requestor){
    QMessageBox message;
    message.setText(requestor + "->" + this->name);
    message.exec();
}

```

<!--endsec-->
