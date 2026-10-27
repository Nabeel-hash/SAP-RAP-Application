@EndUserText.label : 'TMD demo - dropdown values'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #C
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztmd_values {
  key client     : abap.clnt not null;
  key list_id    : abap.char(4) not null;
  key value_code : abap.char(10) not null;
  value_text     : abap.char(40);
  sort_order     : abap.int4;
}
