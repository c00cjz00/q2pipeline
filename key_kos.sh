#!/bin/sh
#
#All genes are from here http://www.genome.jp/kegg-bin/get_htext?htext=ko00002.keg&query=oxygen 
#Genes from GraftM from NE1C2 stuff – Good starting point
mkdir $name/useful/tax4fun/sorted
grep -E "K00370|K00437|K02588|K14138|K00394|K00399|K10944|K16157|K00368|K15864|K00531|K11180|K02274|K00404|K02117|K00437|K00428|K02567|K03385|K02586|K14028" $name/useful/tax4fun/Tax4FunProfile_Export.csv >> $name/useful/tax4fun/sorted/grafM.csv
#Wolfe Cycle 
grep -E "K03388|K00577|K00399|K00437|K00440|K00200|K00672|K01499|K10714|K00320" $name/useful/tax4fun/Tax4FunProfile_Export.csv >> $name/useful/tax4fun/sorted/wolfe.csv
#Wood Ljungdahl
grep -E "K00198|K05299|K15022|K01938|K01491|K00297|K15023|K14138|K00197|K00194" $name/useful/tax4fun/Tax4FunProfile_Export.csv >> $name/useful/tax4fun/sorted/wood.csv
#Genes from DSR pathway M00596
grep -E "K00956|K00957|K00958|K00394|K00395|K11180|K11181" $name/useful/tax4fun/Tax4FunProfile_Export.csv >> $name/useful/tax4fun/sorted/DSR.csv
#
#Acetotrophic methanogenesis M00357
grep -E "K00925|K00625|K13788|K01895|K00193|K00197|K00194|K00577|K00578|K00579|K00580|K00581|K00582|K00583|K00584|K00399|K00400|K00401|K00402|K03388|K03389|K03390" $name/useful/tax4fun/Tax4FunProfile_Export.csv >> $name/useful/tax4fun/sorted/methanogenesis.csv
#
#Denitrification  M00529
grep -E "K00370|K00371|K00374|K02567|K00368|K15864|K04561|K02305|K00376" $name/useful/tax4fun/Tax4FunProfile_Export.csv >> $name/useful/tax4fun/sorted/denitrification.csv
#
#Nitrification M00528
grep -E "K10944|K10945|K10946|K10535" $name/useful/tax4fun/Tax4FunProfile_Export.csv >> $name/useful/tax4fun/sorted/nitrification.csv
#
#Nitrogen Fixation M00175
grep -E "K02588|K02586|K02591|K00531" $name/useful/tax4fun/Tax4FunProfile_Export.csv >> $name/useful/tax4fun/sorted/nitrogen_fixation.csv 
#
#Cytochrome C Oxidase http://www.genome.jp/kegg-bin/show_pathway?ko00190+K02301
grep -E "K02301|K02299|K02276|K02274|K02275" $name/useful/tax4fun/Tax4FunProfile_Export.csv >> $name/useful/tax4fun/sorted/cytochome_c_oxidase.csv
#
grep -E "K00404|K00405|K00406|K00407|K15862" $name/useful/tax4fun/Tax4FunProfile_Export.csv >> $name/useful/tax4fun/sorted/cytochome_c_cbb3.csv
#
grep -E "K02117|K02118|K02119|K02120|K02121|K02122|K02123|K02124" $name/useful/tax4fun/Tax4FunProfile_Export.csv >> $name/useful/tax4fun/sorted/v_a_type_ATPase.csv
#
#Methane oxidation M00174
grep -E "K10944|K10945|K10946|K16157|K16158|K16159|K16160|K16161|K16162|K14028|K14029" $name/useful/tax4fun/Tax4FunProfile_Export.csv >> $name/useful/tax4fun/sorted/methane_oxidation.csv
#
