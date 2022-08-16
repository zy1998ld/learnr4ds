# r4ds 学习之路 [:mag:]

<details>
    <summary>目录</summary>

- [ggplot](#ggplot)

</details>

## ggplot

ggplot**分层**绘图的七个参数

```r
ggplot(data = <data>) +
    geom_<function>(
        mapping = <mapping>,
        stat = <stat>,
        postion = <postion>) +
    coord_<function>() +
    facet_<function>()
```

> `position`: 位置参数，三种`fill`, `identity`, `dodge`对应堆叠、精确重叠对象分组
> `facet`: 分面，facet_wrap | facet_grid
> `coord`:坐标系，常见的 coord_flip | coord_polar

## 数据转换

!!!note 由于对于浮点数的存储并不能达到无限精度，所以 1/49\*49 == 1 这种判断结果为 F，此时需要用到 near(x,y)函数

1. filter 子集化，注意比较和逻辑运算符，注意`%in%`的使用。其中`xor()`对应的是`(x & !y) & (y & !x)` ![布尔运算](imgs/Boolean.png)
   - filter 函数计算时并不会纳入 NA，所以 filter(.data,is.NA(cond)|cond)
2. 缺失值 NA：要正确明白其是未知数，但 NA^0 = 1,NA & T = T，NA + 1 = NA.同时也要注意`lapply`\`apply`和其的联用
3. arrange():缺失值一直排在末尾
4. select():选择变量，注意与 starts_with(),contains(),matchs(),all_of(),one_of()和 everything()调换顺序等联用
5. summarise()与 group_by()联用分组计算结果
