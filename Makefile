CORE_TYPES = river mountain

# all entities with a geonames id
wikidata/geonames.tsv:
	pq-wikidata -l -L enlabel --distinct -f tsv "geonames_id(E,Id)"  > $@.tmp && mv $@.tmp $@
.PRECIOUS: wikidata/geonames-types.tsv

# get all distinct types for anything with a geonames id
wikidata/geonames-types.tsv:
	pq-wikidata -l -L enlabel --distinct -f tsv "geonames_id(E,Id),instance_of(E,T)" "row(T)" > $@.tmp && mv $@.tmp $@
.PRECIOUS: wikidata/geonames-types.tsv

# OPAs for above
wikidata/geonames-types-%.tsv:
	pq-wikidata --distinct -f tsv "geonames_id(E,Id),instance_of(E,T),$*(T,V)" "row(T,V)" > $@.tmp && mv $@.tmp $@
.PRECIOUS: wikidata/geonames-types.tsv

by-type/inst-%.tsv:
	pq-wikidata -d sparqlprog -l -L enlabel -f tsv "$*(I),instance_of(I,T)" "instance_of(I,T)"  > $@.tmp && mv $@.tmp $@

by-type/hier-%.tsv:
	pq-wikidata -l -L enlabel -f tsv "label(C,'$*'@en),subclass_of_transitive(C,A),subclass_of(B,A)" "subclass_of(B,A)"  > $@.tmp && mv $@.tmp $@

by-type/hier-%.ttl:
	pq-wikidata -d sparqlprog -e "extract_subontology('$(subst _, ,$*)','$@.tmp')" && mv $@.tmp $@
.PRECIOUS: by-type/hier-%.ttl

by-type/hier-%.png: by-type/hier-%.ttl
	ontoquery -t viz -p a -i $< .

ontology/wd-geo.ttl:
	owltools --create-ontology foo by-type/*.ttl --merge-support-ontologies  -o -f ttl --prefix wd http://www.wikidata.org/entity/ $@.tmp && mv $@.tmp $@
#	owltools --create-ontology foo by-type/*.ttl --merge-support-ontologies --remove-dangling -o -f ttl $@


# the ontology is fairly useless..
geonames/ont.ttl:	
	curl -L -s http://www.geonames.org/ontology/ontology_v3.1.rdf > $@.tmp && mv $@.tmp $@

# Mixture of schema.org
# also http://linkedgeodata.org/ontology/AbandonedStation 
geonames/mappings.ttl:
	curl -L -s http://www.geonames.org/ontology/mappings_v3.01.rdf > $@.tmp && mv $@.tmp $@

geonames/wd-fcodes.tsv:
	pq-wikidata -l -L enlabel "geonames_feature_code" > $@.tmp && mv $@.tmp $@

# filter entries like region of Italy
%-no-proper.tsv: %.tsv
	egrep -v '\t.*[A-Z]' $< > $@

%-is-proper.tsv: %.tsv
	egrep '\t.*[A-Z]' $< > $@


backup:
	cp matches/wd-gaz-cache.ttl ~/Google\ Drive/OBO\ operations\ committee/OBO\ Gazetteer/gaz-data

osf-backup:
	osf -p unga9 upload -f matches/wd-gaz-cache.ttl wd-gaz-all-matches.ttl

matches/match-%.ttl:
	wd-ontomatch  -d ontomatcher -i $* -a wikidata_ontomatcher:save_frequency=0.02 -a wikidata_ontomatcher:cached_db_file=matches/wd-$*-cache.ttl match_all && cp matches/wd-$*-cache.ttl $@

.PRECIOUS: matches/match-%.ttl

matches/align-full-%.tsv: matches/match-%.ttl
	rdfmatch -G matches/align-full-$*.ttl -f tsv -l -i prefixes/obo_wd_prefixes.ttl -A ~/repos/onto-mirror/void.ttl  -d rdf_matcher -g remove_inexact_synonyms -i $* -i $< exact > $@.tmp && mv $@.tmp $@
.PRECIOUS: matches/align-full-%.tsv

matches/align-high-confidence-%.tsv: matches/align-full-%.tsv
	awk -F"\t" '{ if (NR==1 || $$9 == "high") { print } }'  $< | grep -v 'Wikimedia disambiguation page' >  $@.tmp && mv $@.tmp $@

matches/align-unique-%.tsv: matches/match-%.ttl
	rdfmatch -f tsv -l -i prefixes/obo_wd_prefixes.ttl -A ~/repos/onto-mirror/void.ttl -d rdf_matcher -g remove_inexact_synonyms -i $* -i $< unique_match > $@.tmp && mv $@.tmp $@


matches/align-all-%.tsv: matches/match-%.ttl
	rdfmatch -f tsv -l -i prefixes/obo_wd_prefixes.ttl -A ~/repos/onto-mirror/void.ttl -i $* -i $< new_match > $@.tmp && mv $@.tmp $@

matches/no-align-%.tsv: matches/match-%.ttl
	rdfmatch -f tsv -l -i prefixes/obo_wd_prefixes.ttl -A ~/repos/onto-mirror/void.ttl -i $* -i $< unmatched obo > $@.tmp && mv $@.tmp $@
