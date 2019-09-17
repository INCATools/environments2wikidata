#!/usr/bin/perl

print "\@prefix      obo: <http://purl.obolibrary.org/obo/> .\n";
print "\@prefix    sweet: <http://sweetontology.net/> .\n";
print "\@prefix       wd: <http://www.wikidata.org/entity/> .\n";
print "\@prefix      owl: <http://www.w3.org/2002/07/owl#> .\n";
print "\n";
while(<>) {
    next if m@^c1\t@;
    next unless m@^obo:.*wd:Q@ || m@^sweet.*wd:Q@;
    if (m@^(\S+)\t([\S ]+)\t(\S+)@) {
        print "$1 owl:equivalentClass $3 .\n";
    }
}
