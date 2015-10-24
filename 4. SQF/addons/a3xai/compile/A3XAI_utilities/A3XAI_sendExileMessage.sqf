#include "\A3XAI\globaldefines.hpp"

private["_messageName","_messageParameters","_player"];
_player = _this select 0;
_messageName = _this select 1;
_messageParameters = _this select 2;

_publicMessage = [_messageName, _messageParameters];
_publicMessage remoteExecCall ["ExileClient_system_network_dispatchIncomingMessage",(owner _player)];

true
