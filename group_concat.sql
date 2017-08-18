CREATE OR REPLACE FUNCTION group_concat_iterate(_state INTEGER[], _value INTEGER)
  RETURNS INTEGER[] AS
$BODY$
  SELECT
    CASE
      WHEN $1 IS NULL THEN ARRAY[$2]
      ELSE $1 || $2
  END
$BODY$
  LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION group_concat_finish(_state INTEGER[])
  RETURNS text AS
$BODY$
    SELECT array_to_string($1, ',')
$BODY$
  LANGUAGE SQL VOLATILE;

CREATE AGGREGATE group_concat(int) (SFUNC = group_concat_iterate, STYPE = INTEGER[], FINALFUNC = group_concat_finish);