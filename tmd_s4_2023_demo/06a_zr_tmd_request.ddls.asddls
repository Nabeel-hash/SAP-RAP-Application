@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TMD demo - request (R)'
define root view entity ZR_TMD_Request
  as select from ztmd_req
  composition [0..*] of ZR_TMD_Target as _Target
{
  key request_uuid          as RequestUUID,
      request_id            as RequestID,
      scenario_id           as ScenarioID,
      replicate_mode        as ReplicateMode,
      is_street_mode        as IsStreetMode,
      is_apartment_mode     as IsApartmentMode,
      ref_connection_object as RefConnectionObject,
      ref_premise           as RefPremise,
      reuse_connection_obj  as ReuseConnectionObject,
      number_of_objects     as NumberOfObjects,
      house_number          as HouseNumber,
      increment_value       as IncrementValue,
      increment_by          as IncrementBy,
      street_direction      as StreetDirection,
      street_name           as StreetName,
      street_suffix         as StreetSuffix,
      unit_type             as UnitType,
      letter_number_format  as LetterNumberFormat,
      start_letter          as StartLetter,
      start_number          as StartNumber,
      street_supplement     as StreetSupplement,
      city_name             as CityName,
      postal_code           as PostalCode,
      region                as Region,
      country               as Country,
      premise_type          as PremiseType,
      maintenance_plant     as MaintenancePlant,
      key_date              as KeyDate,
      status                as Status,
      status_text           as StatusText,
      status_criticality    as StatusCriticality,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Target
}
