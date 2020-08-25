# TODO: check all `unknown` fields
meta:
  id: hplus_smartwatch
  title: BLE smartwatch protocol Hplus
  license: CC0-1.0
  ks-version: 0.8
  endian: le
doc: |
  The communication protocol between BLE smartwatch breed and Hplus app (for
  Android and iOS)
doc-ref: https://github.com/Freeyourgadget/Gadgetbridge/wiki/HPlus-Protocol

enums:
  hplus_commands_enum:
    0x01: unknown
    0x04: unknown
    0x05: unknown
    0x08: set_date
    0x09: set_time
    0x0a: set_inactivity_timers
    0x0b: unknown
    0x15: unknown
    0x16: unknown
    0x17: unknown
    0x19: unknown
    0x22: unknown
    0x24: unknown
    0x26: unknown
    0x27: unknown
    0x2a: set_day_of_the_week
    0x2c: unknown
    0x2d: unknown
    0x35: set_all_day_heart_rate_measurement
    0x47: unknown
    0x48: unknown
    0x4d: unknown
    0x4f: unknown
  all_day_heart_rate_measurement_switch_enum:
    0x0a: on
    0xff: off

  hplus_response_enum:
    0x18: sw_version_18
    0x1a: unknown # 18 bytes
    0x2e: sw_version_2e
    0x33: current_stats
    0x36: unknown # 18 bytes
    0x38: day_summary_data_38
    0x39: day_summary_data_39
    0x4d: unknown # 19 bytes

types:
  null_type: {}
  app2device:
    seq:
      - id: command
        type: u1
        enum: hplus_commands_enum
      - id: params
        type:
          switch-on: command
          cases:
            'hplus_commands_enum::set_date': app2device_set_date_params
            'hplus_commands_enum::set_time': app2device_set_time_params
            'hplus_commands_enum::set_inactivity_timers': app2device_set_inactivity_timers_params
            'hplus_commands_enum::set_day_of_the_week': u1 # day_number
            'hplus_commands_enum::set_all_day_heart_rate_measurement': u1 # all_day_heart_rate_measurement_switch_enum
            _: null_type
  app2device_set_date_params:
    # command 0x08
    seq:
      - id: year
        type: u2be
      - id: month
        type: u1
      - id: day
        type: u1
  app2device_set_time_params:
    # command 0x09
    seq:
      - id: hour
        type: u1
      - id: minute
        type: u1
      - id: second
        type: u1
  app2device_set_inactivity_timers_params:
    # command 0x2a
    seq:
      - id: start_hour
        type: u1
      - id: start_minute
        type: u1
      - id: end_hour
        type: u1
      - id: end_minute
        type: u1

  device2app:
    seq:
      - id: response
        type: u1
        enum: hplus_response_enum
      - id: params
        type:
          switch-on: response
          cases:
            'hplus_response_enum::sw_version_18': device2app_sw_version_18_params
            'hplus_response_enum::sw_version_2e': device2app_sw_version_2e_params
            'hplus_response_enum::current_stats': device2app_current_stats_params
            'hplus_response_enum::day_summary_data_38': device2app_day_summary_data_params
#            'hplus_response_enum::day_summary_data_39': device2app_day_summary_data_params
            _: null_type
  device2app_sw_version_18_params:
    # response 0x18
    seq:
      - id: minor
        type: u1
      - id: major
        type: u1
  device2app_sw_version_2e_params:
    # response 0x2e
    seq:
      - id: hr_minor
        type: u1
      - id: hr_major
        type: u1
      - id: unknown
        type: u1
        repeat: expr
        repeat-expr: 6
      - id: minor
        type: u1
      - id: major
        type: u1
      # + may be BT-MAC
  device2app_current_stats_params:
    # response 0x33
    seq:
      - id: steps
        type: u2be
      - id: distance
        type: u2be
      - id: calories1
        type: u2be
      - id: calories2
        type: u2be
      - id: battery
        type: u1
      - id: unknown
        type: u1
      - id: heart_rate
        type: u1
      - id: active_time
        type: u2be
  device2app_day_summary_data_params:
    # response 0x38 and 0x39
    seq:
      - id: steps
        type: u2be
      - id: distance
        type: u2be
      - id: calories1
        type: u2be
      - id: calories2
        type: u2be
      - id: year
        type: u2be
      - id: month
        type: u1
      - id: day
        type: u1
      - id: active_time
        type: u2be
      - id: max_heart_rate
        type: u1
      - id: min_heart_rate
        type: u1

