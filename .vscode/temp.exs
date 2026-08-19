alias Larabot.Error
alias Nostrum.Api.Message

message =
  1_044_365_513_968_595_004
  |> Message.get(1_523_456_349_420_388_513)
  |> Error.handle!()
  |> dbg

message
|> Larabot.Impersonate.impersonate(files_behavior: :clone)
|> Error.handle!()
|> dbg
