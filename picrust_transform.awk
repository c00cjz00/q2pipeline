#!/usr/bin/awk

function percent(value, total) {
    return sprintf("%.8f", 100 * value / total)
}
BEGIN { OFS = "\t" }
NR == 1 { gsub(/ +/, OFS); print; next }
{
    label[NR] = $1
    for (i = 2; i <= NF; ++i) {
        sum[i] += col[i, NR] = $i
    }
}
END {
    for (j = 2; j <= NR; ++j) {
        $1 = label[j]
        for (i = 2; i <= NF; ++i) {
            $i = percent(col[i, j], sum[i])
        }
        print
    }
}