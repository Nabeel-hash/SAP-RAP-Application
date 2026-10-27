@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TMD demo - target row (R)'
define view entity ZR_TMD_Target
  as select from ztmd_tgt
  association to parent ZR_TMD_Request as _Request on $projection.RequestUUID = _Request.RequestUUID
{
  key target_uuid           as TargetUUID,
      request_uuid          as RequestUUID,
      group_no              as GroupNo,
      seq_no                as SeqNo,
      house_number          as HouseNumber,
      street                as Street,
      supplement            as Supplement,
      street_supplement     as StreetSupplement,
      premise_type          as PremiseType,
      connection_object     as ConnectionObject,
      premise               as Premise,
      devloc_electric       as DevLocElectric,
      devloc_gas            as DevLocGas,
      devloc_light          as DevLocLight,
      row_status            as RowStatus,
      row_message           as RowMessage,
      row_criticality       as RowCriticality,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Request
}
