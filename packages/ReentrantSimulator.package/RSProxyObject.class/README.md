I am a proxy that forwards all message sends to my proxiedObject.
Before forwarding a message, I signal a RSRestartTracingNotification to potentially re-enter simulation for the duration of the message send to my proxiedObject if a reentrant simulator is currently active.

I should behave nearly identical to an my instance of proxiedObject, except when sending #== or #~=.

To create a new instance of myself, i.e., to wrap an object with myself, send #wrap: to my class.
I will take care of not wrapping instances of myself.