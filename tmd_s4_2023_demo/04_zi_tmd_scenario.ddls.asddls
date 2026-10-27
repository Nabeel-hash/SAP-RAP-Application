@EndUserText.label: 'TMD demo - scenario'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZI_TMD_Scenario
  as select from ztmd_scen
{
  key scenario_id    as ScenarioID,
      description    as Description,
      electric_flag  as ElectricFlag,
      gas_flag       as GasFlag,
      light_flag     as LightFlag,
      max_rows_total as MaxRowsTotal
}
