// Draft table for ZR_TMD_Target (same advice: prefer the Ctrl+1 quick fix in the BDEF).
@EndUserText.label : 'Draft table for ZR_TMD_Target'
@AbapCatalog.enhancement.category : #EXTENSIBLE_ANY
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztmd_tgt_d {
  key mandt          : mandt not null;
  key targetuuid     : sysuuid_x16 not null;
  requestuuid        : sysuuid_x16;
  groupno            : abap.int4;
  seqno              : abap.int4;
  housenumber        : abap.char(10);
  street             : abap.char(60);
  supplement         : abap.char(10);
  streetsupplement   : abap.char(40);
  premisetype        : abap.char(8);
  connectionobject   : abap.char(30);
  premise            : abap.char(10);
  devlocelectric     : abap.char(30);
  devlocgas          : abap.char(30);
  devloclight        : abap.char(30);
  rowstatus          : abap.char(1);
  rowmessage         : abap.char(220);
  rowcriticality     : abap.int1;
  locallastchangedat : abp_locinst_lastchange_tstmpl;
  "%admin"           : include sych_bdl_draft_admin_inc;
}
