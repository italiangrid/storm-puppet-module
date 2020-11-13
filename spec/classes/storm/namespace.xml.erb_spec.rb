require 'spec_helper'

describe 'namespace.xml.erb' do
  let(:scope) { Puppet::Parser::Scope }

  let(:harness) { TemplateHarness.new('templates/etc/storm/backend-server/namespace.xml.erb', scope) }

  let(:storage_areas) do
    [
      {
        'name' => 'test.vo',
        'root_path' => '/storage/test.vo',
        'access_points' => ['/test.vo'],
        'vos' => ['test.vo', 'test.vo.2'],
        'storage_class' => 'T1D1',
        'online_size' => 4,
        'nearline_size' => 10,
        'transfer_protocols' => ['file', 'gsiftp', 'root', 'http', 'https'],
      },
      {
        'name' => 'atlas',
        'root_path' => '/storage/atlas',
        'access_points' => ['/atlas', '/atlasdisk'],
        'vos' => ['atlas'],
        'fs_type' => 'gpfs',
        'storage_class' => 'T0D1',
        'online_size' => 4,
        'nearline_size' => 10,
        'transfer_protocols' => ['file', 'gsiftp'],
        'gsiftp_pool_balance_strategy' => 'weight',
        'gsiftp_pool_members' => [
          {
            'hostname' => 'gridftp-0.example.com',
            'weight' => 50,
          }, {
            'hostname' => 'gridftp-1.example.com',
          }
        ],
      },
    ]
  end

  let(:gsiftp_pool_members) do
    [
      {
        'hostname' => 'gridftp-0.example.com',
      }, {
        'hostname' => 'gridftp-1.example.com',
      }
    ]
  end

  let(:webdav_pool_members) do
    [
      {
        'hostname' => 'webdav-0.example.com',
      }, {
        'hostname' => 'webdav-1.example.com',
      }
    ]
  end

  it 'has two storage areas' do
    expect(storage_areas.size).to eq(2)
  end

  it 'render the same file each time' do
    harness.set('@storage_areas', storage_areas)
    harness.set('@gsiftp_pool_members', gsiftp_pool_members)
    harness.set('@webdav_pool_members', webdav_pool_members)

    rendered = harness.run

    xml_doc = Nokogiri::XML(rendered)
    expect(xml_doc.xpath('//filesystem')).not_to be_empty

    namespace = Nokogiri::Slop(rendered)
    expect(namespace.search('filesystems').search('filesystem').first.root.text).to eq('/storage/test.vo')

    schema = Nokogiri::XML::Schema(my_fixture_read('namespace.xsd'))
    errors = schema.validate(xml_doc)

    puts rendered

    errors.each do |error|
      puts error.message
    end

    expect(errors).to match_array([])
  end
end
