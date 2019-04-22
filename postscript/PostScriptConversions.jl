function cm_to_pt(cm)
    return inch_to_pt(cm_to_inch(cm))
end

function cm_to_inch(cm)
    return cm / 2.54
end

function inch_to_pt(inches)
    return 72 * inches
end

println(cm_to_pt(10.5))