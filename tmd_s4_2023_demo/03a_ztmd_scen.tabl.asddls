@EndUserText.label : 'TMD demo - scenario configuration'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #C
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztmd_scen {
  key client        : abap.clnt not null;
  key scenario_id   : abap.char(3) not null;
  description       : abap.char(60);
  electric_flag     : abap_boolean;
  gas_flag          : abap_boolean;
  light_flag        : abap_boolean;
  max_rows_total    : abap.int4;
}
