# @summary The Pool type for storm-backend-server
type Storm::Backend::Pool = Struct[{
  balance_strategy => Optional[Enum['round-robin', 'smart-rr', 'random', 'weight']],
  members          => Array[Struct[{
    hostname => String,
    port     => Optional[Integer],
    weigth   => Optional[Integer],
  }]],
}]
