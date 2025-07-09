# 命题逻辑语法分析器
贵州大学2025数理逻辑期末大作业项目一

授课老师：王以松教授

## 使用说明

## 0、环境准备（安装flex和bison）：
```bash
sudo apt install flex bison
```

## 1、编译步骤：
```bash
flex prop_lexer.l
bison -d prop_parser.y
gcc -finput-charset=UTF-8 -o prop_parser prop_parser.tab.c lex.yy.c ast.c -lfl
```

## 2、测试示例：
```bash
echo "((p ∧ q) → r)" | ./prop_parser
```

## 3、语法树输出：
程序会输出解析后的抽象语法树 (AST)，例如对于输入((p ∧ q) → r)，输出如下：

```plaintext
根节点类型: 6
语法分析成功！
IMPLIES
  AND
    ID: p
    ID: q
  ID: r
```

该项目基本支持所有基本命题逻辑运算符，包括否定 (¬)、合取 (∧)、析取 (∨)、蕴含 (→) 和等价 (↔)，并正确处理了运算符优先级。

## License
This project is licensed under the [MIT License](LICENSE).
