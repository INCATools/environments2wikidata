# environments2wikidata

tools and results for mining connections between wikidata entries and ENVO or GAZ.

The resulting mappings can connect GAZ to ENVO, as per the following schema:

```

                      (wd curated)
   wikidata:<Place> --[rdf:type]-->   wikidata:<PlaceType>
         |                              |
         |                              |
      skos:match                      skos:match
         |                              |
         |                              |
   GAZ:<GAZ_ID>    ---[rdf:type]-->   wikidata:<PlaceType>
                      (inferred)


```

For more details and contex, see the following tickets:

 * [envo#833](https://github.com/EnvironmentOntology/envo/issues/833) ENVO to Wikidata mappings
 * [gaz#3](https://github.com/EnvironmentOntology/gaz/issues/3) Upload all of GAZ to wikidata
 * [gaz#20](https://github.com/EnvironmentOntology/gaz/issues/20) convert GAZ to instance-based

## Results

 * All triples are stored on OSF (>100M): [https://osf.io/unga9/](https://osf.io/unga9/)
 * [curated-high-confidence-envo.tsv](https://github.com/cmungall/environments2wikidata/blob/master/matches/curated-high-confidence-envo.tsv)
 * [align-high-confidence-gaz.tsv](https://github.com/cmungall/environments2wikidata/blob/master/matches/align-high-confidence-gaz.tsv)
