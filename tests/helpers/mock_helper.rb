# Use so you can run in mock mode from the command line
#
# FOG_MOCK=true fog

Fog.mock! if ENV["FOG_MOCK"] == "true"

# if in mocked mode, fill in some fake credentials for us
if Fog.mock?
  Fog.credentials = {
      # no need extra credentials
  }.merge(Fog.credentials)
end
