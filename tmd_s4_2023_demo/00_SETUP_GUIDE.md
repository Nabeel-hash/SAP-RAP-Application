# Custom Premise Replicator – hands-on demo for S/4HANA 2023 (ABAP Cloud, RAP, Fiori elements)

This package gives you the complete flow of the Mass TMD Replicator in Eclipse (ADT 2026-09) on an
**S/4HANA 2023** system **without IS-U data**:

Fiori screen → dropdowns and show/hide → reference look-up → **Replicate** (generate + duplicate check)
→ **Save** → **Create Objects** → created numbers per row + success message.

## What is real and what is simulated

| Part | In this demo | On S/4HANA 2025 (target) |
| --- | --- | --- |
| Fiori screen, draft, value helps, show/hide, side effects | Real (RAP + Fiori elements) | Same |
| Address generator + ABAP Unit tests | Real | Same |
| Scenario matrix S01–S08 | Real (table ZTMD_SCEN) | Same + Business Configuration app |
| Maintenance plant | **Real MM data** (released view `I_Plant`) | Same |
| Country / Region | Real (`I_CountryVH`, `I_RegionVH`) | Same |
| Connection Object / Premise / Device Location creation | **Simulated** by `ZCL_TMD_DEMO_ENGINE`, numbers like CO00000002, stored in `ZTMD_OBJ` | Released RAP BOs `I_UtilitiesConnectionObjectTP`, `…PremiseTP`, `…DeviceLocationTP` |
| Reference CO / premise look-up | From `ZTMD_OBJ` | `I_UtilitiesPremise`, `I_UtilsTechObjLocationAddr` |
| Execution | Synchronous in the "Create Objects" action, saved by the RAP saver | Background (bgPF), one LUW per CO group, restartable |
| Characteristics copy, application log, authorization object | Left out | See design doc |

Everything used is released for ABAP Cloud on 2023 (checked against SAP's Cloudification Repository, PCE 2023 FPS00).

## Before you start

* ADT connected to the 2023 system, user with developer authorization.
* If the system lets you, use a transportable package; otherwise a local package (`$TMD_DEMO`) is fine.
* Publishing an OData V4 service needs Gateway authorization. If the **Publish** button in the service
  binding fails, ask Basis to publish the service group in transaction `/IWFND/V4_ADMIN`.

## Creation order (do it exactly in this order)

Tip: after pasting each source, **Ctrl+S** and **Ctrl+F3** (activate). Where two objects reference each
other, use **Activate all inactive objects** (Ctrl+Shift+F3).

| Step | File | Object | ADT menu (right-click package → New → …) |
| --- | --- | --- | --- |
| 1 | – | Package `ZTMD_DEMO` | ABAP Package. In the package properties set **ABAP Language Version = ABAP for Cloud Development** |
| 2 | (below) | Message class `ZTMD` | Other ABAP Repository Object → Message Class. Add the messages from the table below |
| 3 | 03a–03e | Tables `ZTMD_SCEN`, `ZTMD_VALUES`, `ZTMD_REQ`, `ZTMD_TGT`, `ZTMD_OBJ` | Other → Dictionary → Database Table. Replace the generated source |
| 4 | 04 | CDS `ZI_TMD_Scenario` | Other → Core Data Services → Data Definition |
| 5 | 05_* (9 files) | Value-help views `ZI_TMD_…VH` | Data Definition (one per file) |
| 6 | 06a + 06b | `ZR_TMD_Request`, `ZR_TMD_Target` | Data Definition. Create both, then **Activate all** (they reference each other) |
| 7 | 09 | Class `ZCX_TMD` | ABAP Class |
| 8 | 10 | Class `ZCL_TMD_ADDRESS_GENERATOR` | ABAP Class. Paste the `.testclasses` file into the **Test Classes** tab |
| 9 | 11 | Class `ZCL_TMD_DEMO_ENGINE` | ABAP Class |
| 10 | 08 | Behavior definition `ZR_TMD_REQUEST` | Right-click `ZR_TMD_Request` → New Behavior Definition. Replace the source |
| 11 | 07a + 07b | Draft tables `ZTMD_REQ_D`, `ZTMD_TGT_D` | In the BDEF, cursor on `ztmd_req_d` → **Ctrl+1 → Create draft table** (same for `ztmd_tgt_d`). Use 07a/07b only if the quick fix is not offered |
| 12 | 13 (+ locals) | Behavior pool `ZBP_R_TMD_REQUEST` | In the BDEF line 1, cursor on `zbp_r_tmd_request` → **Ctrl+1 → Create behavior implementation**. Paste `13_…locals_imp.abap` into the **Local Types** tab. Activate BDEF + class together |
| 13 | 12a + 12b | Projections `ZC_TMD_Request`, `ZC_TMD_Target` | Data Definition (template "Define Projection View"). Activate all |
| 14 | 14 | Projection BDEF `ZC_TMD_REQUEST` | Right-click `ZC_TMD_Request` → New Behavior Definition |
| 15 | 15a + 15b | Metadata extensions `ZC_TMD_REQUEST`, `ZC_TMD_TARGET` | Other → Core Data Services → Metadata Extension |
| 16 | 16 | Service definition `ZUI_TMD_REQUEST` | Other → Business Services → Service Definition |
| 17 | – | Service binding `ZUI_TMD_REQUEST_O4` | Right-click the service definition → New Service Binding. Binding type **OData V4 – UI**. Activate → **Publish** |
| 18 | 17 | Class `ZCL_TMD_DEMO_SETUP` | ABAP Class. Activate, then **F9** (Run as Console Application) to load scenarios, dropdowns and the reference CO |
| 19 | – | Preview | Open the service binding, select entity **Request**, click **Preview…** → the Fiori elements app opens in the browser |

### Message class ZTMD

| No. | Text |
| --- | --- |
| 000 | &1&2&3&4 |
| 001 | No Premise or Connection Object &1 exists |
| 010 | Unsupported replicate mode &1 |
| 011 | Number of objects must be between 1 and &1 |
| 012 | Street name is required |
| 013 | Invalid starting house number &1 |
| 014 | Increment must be greater than zero |
| 015 | Invalid apartment format &1 |
| 016 | Start letter must be A-Z |
| 017 | Start number must not be negative |
| 018 | Supplement &1 is longer than &2 characters |
| 019 | Letter sequence starting at &1 runs past Z (offset &2) |
| 020 | Scenario &1 is not configured |
| 021 | Maximum &1 objects per request |
| 022 | Premise &1 with supplement &2 already exists |
| 023 | Connection Object &1 already exists at this address |
| 025 | &1 objects created |
| 026 | Plant &1 does not exist |

## Try the flow (test script)

Pick a real plant from your MM data in **Maintenance Plant** (the value help lists `I_Plant`).

**A. Street Number replication (spec positive tests 3 and 12)**
1. List page → **Create**. The form opens with Country = US, Replicate = Street Number.
2. Service / Scenario **S03** (Electric / Gas). No of Connection Objects **3**, Start House Number **100**,
   Increment Value **2**, Street Direction **N**, Street Name **Main**, Street Suffix **ST**,
   City **Spokane**, Postal Code **99201**, Region **WA**, Maintenance Plant = your plant.
3. Click **Replicate** (footer). The table shows 3 rows: 100, 102, 104 – `N MAIN ST`, message "OK – will be created".
4. **Save**. Status = "Ready – save and create". Click **Create Objects** (header).
5. Each row now shows its own CO, a premise, DL Electric and DL Gas. Toast: "12 objects created"
   (3 CO + 3 premises + 6 DLs = premises × divisions).

**B. Apartment complex on a reference CO, with a duplicate (positive test 13, negative test 4)**
1. **Create** → Scenario **S06**. Set Replicate = **Apartment Number**: the form switches
   (Increment By, Start Letter, Start Number, Letter Number Format appear; the labels change to
   "Number of Premises" / "House Number").
2. Connection Object → value help → **CO00000001**. The address fills in by itself; "Reuse Connection Object" is ticked.
3. Number of Premises **4**, Unit Type **APT**, Letter Number Format **A1**, Increment By **Number**,
   Start Letter **A**, Start Number **1**, plant. **Replicate**.
4. Rows APT A1 and APT A2 are red: "Premise P000000001 with supplement APT A1 already exists".
   Status "Check rows"; **Create Objects** stays disabled.
5. Change Start Number to **3** → **Replicate** → APT A3 … APT A6, all OK → Save → **Create Objects**.
   Four premises appear under CO00000001, each with an Electric and a Gas DL.

**C. Other checks**
* Letter Number Format **N**, Unit Type **UNIT**, Start Number **101** → UNIT 101, UNIT 102 … (positive test 14).
* Increment By **Letter**, Start Letter **Y**, 3 premises → Replicate → "Letter sequence … runs past Z" (negative test 10).
* Increment Value **0** → Save → error on the field (negative test 8).
* Generator unit tests: open `ZCL_TMD_ADDRESS_GENERATOR` → **Ctrl+Shift+F10**.
* Data: **F8** (Data Preview) on `ZTMD_OBJ` shows every simulated CO / premise / DL.
* Reset everything: run `ZCL_TMD_DEMO_SETUP` again (F9).

## If something does not activate

| Symptom | Fix |
| --- | --- |
| `hidden: #(IsStreetMode)` gives a warning / fields never hide | Your SP does not take a field reference there. The form still works (all fields visible). Optional: add `UI.Hidden Path="IsStreetMode"` in a local annotation file of a generated Fiori app |
| `side effects` block not accepted | Delete the block in 08 and `use side effects;` in 14. The flow works; the form refreshes after Replicate / Save instead of immediately |
| `determining: true` unknown | Remove it: the Replicate button then shows in the header toolbar instead of the footer |
| Draft table quick fix missing | Create 07a / 07b manually (field names = CDS element names) |
| Preview button missing / 403 | Service not published: `/IWFND/V4_ADMIN` (Basis) |
| Package language version cannot be set | The code also activates in Standard ABAP; you only lose the cloud-readiness check |

## Moving to the real thing on 2025

Replace `ZCL_TMD_DEMO_ENGINE` with `ZCL_TMD_API_RAP` + `ZCL_TMD_BGPF_OP` from the target package
(`tmd_clean_core.zip`), switch the two value helps to the released Utilities views, and drop `ZTMD_OBJ`.
UI, model, generator, scenario table and tests stay as they are.
