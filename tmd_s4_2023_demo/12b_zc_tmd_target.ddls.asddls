@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Generated premise'
define view entity ZC_TMD_Target
  as projection on ZR_TMD_Target
{
  key TargetUUID,
      RequestUUID,
      @EndUserText.label: 'Group'
      GroupNo,
      @EndUserText.label: '#'
      SeqNo,
      @EndUserText.label: 'House No.'
      HouseNumber,
      @EndUserText.label: 'Street'
      Street,
      @EndUserText.label: 'Supplement'
      Supplement,
      @EndUserText.label: 'Street Supplement 1'
      StreetSupplement,
      @EndUserText.label: 'Premise Type'
      PremiseType,
      @EndUserText.label: 'Connection Object'
      ConnectionObject,
      @EndUserText.label: 'Premise'
      Premise,
      @EndUserText.label: 'DL Electric'
      DevLocElectric,
      @EndUserText.label: 'DL Gas'
      DevLocGas,
      @EndUserText.label: 'DL Light'
      DevLocLight,
      @EndUserText.label: 'Row Status'
      RowStatus,
      @EndUserText.label: 'Message'
      RowMessage,
      RowCriticality,
      LocalLastChangedAt,

      _Request : redirected to parent ZC_TMD_Request
}
