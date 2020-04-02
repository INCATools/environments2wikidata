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
   GAZ:<GAZ_ID>    ---[rdf:type]-->   ENVO:<ENVO_ID>
                      (inferred)


```

For more details and contex, see the following tickets:

 * [envo#833](https://github.com/EnvironmentOntology/envo/issues/833) ENVO to Wikidata mappings
 * [gaz#3](https://github.com/EnvironmentOntology/gaz/issues/3) Upload all of GAZ to wikidata
 * [gaz#20](https://github.com/EnvironmentOntology/gaz/issues/20) convert GAZ to instance-based

## Results

 * [curated-high-confidence-envo.tsv](https://github.com/cmungall/environments2wikidata/blob/master/matches/curated-high-confidence-envo.tsv) (~1k)
 * [align-high-confidence-gaz.tsv](https://github.com/cmungall/environments2wikidata/blob/master/matches/align-high-confidence-gaz.tsv) (~167k)
 * [gaz-to-envo.tsv](https://github.com/cmungall/environments2wikidata/blob/master/matches/gaz-to-envo.tsv) (~26k)

Note that intermediate results of first pass search of GAZ is store on OSF:

 * All triples are stored on OSF (>100M): [https://osf.io/unga9/](https://osf.io/unga9/)

## Methods

### Scan and extract of wikidata

[wikidata_ontomatcher](https://github.com/cmungall/wikidata_ontomatcher)
is used to do a first pass search of wikidata using all classes in an
ontology.

The results are an intermediate ttl file containing skos mapping
triples, plus triples about the matched entities in wikidata. This may
have many false positives due to homonyms.

### Alignment

The above is used to do a more fine grained alignment using [rdf_matcher](https://github.com/cmungall/rdf_matcher) using the `exact` command.

These are then filtered to obtain only high-quality mappings

### GAZ to ENVO

This is simply a join between the rdf:types asserted in Wikidata and the matches.

Due to the conservative nature of both mappings we only get a fraction of GAZ entities with a type as this time (5%)

## Future

We plan to use the conservative mappings to further boost results using kBOOM.

We also want to upload mappings to wikidata and have the community help extend mappings.

Also: GAZ to geonames.
