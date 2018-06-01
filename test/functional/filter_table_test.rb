require 'functional/helper'

describe '3103 default methods for filter table' do
  include FunctionalHelper

  it 'positive tests should pass' do
    controls = [
      '3103_where_defined',
      '3103_entries_defined',
      '3103_raw_data_defined',
      '3103_exists_defined',
      '3103_count_defined',
    ]

    cmd  = 'exec ' + File.join(profile_path, 'filter_table')
    cmd += ' --reporter json --no-create-lockfile' 
    cmd += ' --controls ' + controls.join(' ')
    cmd = inspec(cmd)

    # RSpec keeps issuing a deprecation count to stdout; I can't seem to disable it.
    output = cmd.stdout.split("\n").reject {|line| line =~ /deprecation/}.join("\n")
    data = JSON.parse(output)
    failed_controls = data['profiles'][0]['controls'].select { |ctl| ctl['results'][0]['status'] == 'failed' }
    control_hash = {}
    failed_controls.each do |ctl|
      control_hash[ctl['id']] = ctl['results'][0]['message']
    end
    control_hash.must_be_empty
    cmd.exit_status.must_equal 0
  end
end
