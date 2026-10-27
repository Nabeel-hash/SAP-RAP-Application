@EndUserText.label : 'TMD demo - generated target row'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztmd_tgt {
  key client             : abap.clnt not null;
  key target_uuid        : sysuuid_x16 not null;
  request_uuid           : sysuuid_x16 not null;
  group_no               : abap.int4;
  seq_no                 : abap.int4;
  house_number           : abap.char(10);
  street                 : abap.char(60);
  supplement             : abap.char(10);
  street_supplement      : abap.char(40);
  premise_type           : abap.char(8);
  connection_object      : abap.char(30);
  premise                : abap.char(10);
  devloc_electric        : abap.char(30);
  devloc_gas             : abap.char(30);
  devloc_light           : abap.char(30);
  row_status             : abap.char(1);
  row_message            : abap.char(220);
  row_criticality        : abap.int1;
  local_last_changed_at  : abp_locinst_lastchange_tstmpl;
}
