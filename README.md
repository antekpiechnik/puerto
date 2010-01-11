# Important!!!
The concept below is a *draft*! It will change for sure -- the main task to do
for now is to refactor {AbstractPuerto} to some kind of handler class and make
{Puerto} the singleton main class only inheriting from the mentioned handler
class because it will be main menu handler itself.

# Concept
The main class of game is {AbstractPuerto}. Concept is based on _handlers_.
Handler is a class responsible for doing certain jobs and responding for user
input. {AbstractPuerto} uses {AbstractPuerto#handle} to dispatch methods which
may affect handler.

# Main class
{Puerto} class is instance of {AbstractPuerto} and is considered the main class
-- the one which sets handlers and dispatches methods. It is also a handler
itself responsible for main menu.
