ggplot(
    data = newdata,
    aes(x = reorder(ID, urpercent.abs, FUN = mean, na.rm = TRUE), y = urpercent.abs)
) +
    stat_summary(fun.data = "mean_cl_normal")

ggplot(
    data = newdata,
    aes(x = percent.absentee, y = urpercent.abs)
) +
    geom_point(alpha = .4)

ggplot(  # completely pooled
    data = newdata,
    aes(x = percent.absentee, y = urpercent.abs)
) +
    geom_point(alpha = .4) +
    geom_smooth(method='lm', se=FALSE)

ggplot(  # completely separated
    data=newdata,
    aes(x=percent.absentee, y=urpercent.abs)
) +
    geom_point(alpha = .4) +
    geom_smooth(aes(group=factor(ID)), method='lm', se=FALSE)
    
