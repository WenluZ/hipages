{% macro update_or_add_load_ts() %}
    
    {%- set target_relation = adapter.get_relation(
          database=this.database,
          schema=this.schema,
          identifier=this.name) -%}
    {%- set table_exists = target_relation is not none -%}

    {%- set column_name = 'load_ts' -%}
    
    {%- if table_exists -%}
        {%- set columns = adapter.get_columns_in_relation(target_relation) -%}
        {%- set dest_cols = columns | map(attribute ='quoted') | join(', ') -%}
        
        {%- set column_exists = column_name in dest_cols -%}
        
        {%- if column_exists -%}
            {% set sql -%}
                UPDATE {{ this.database }}.{{ this.schema }}.{{ this.name }}
                SET {{ column_name }} = NOW();
             {% endset %}    
        {%- else -%}
            {% set sql -%}
                ALTER TABLE {{ this.database }}.{{ this.schema }}.{{ this.name }}
                ADD COLUMN {{ column_name }} TIMESTAMP DEFAULT NOW();
             {% endset %}    
        {%- endif %}
        {% do run_query(sql) %}
    {%- else -%}
        {{ log('Target table doesnt exist', info=True) }}
    {%- endif %}
{% endmacro %}
