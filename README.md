# 命题逻辑语法分析器
2025数理逻辑期末大作业项目一
## 使用说明

## 编译步骤：
```bash
flex prop_lexer.l
bison -d prop_parser.y
gcc -o prop_parser prop_parser.tab.c lex.yy.c -lfl
```

## 测试示例：
```bash
echo "(p ∧ q) → r" | ./prop_parser
```

## 语法树输出：
程序会输出解析后的抽象语法树 (AST)，例如对于输入(p ∧ q) → r，输出如下：

```plaintext
IMPLIES
  AND
    ID: p
    ID: q
  ID: r
```

该实现支持所有基本命题逻辑运算符，包括否定 (¬)、合取 (∧)、析取 (∨)、蕴含 (→) 和等价 (↔)，并正确处理了运算符优先级。
