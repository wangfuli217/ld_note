====== Logging Messages ======

Here is a more succinct **date** format with the process ID:

<code bash>
echo $(date '+%F %T') $$: Status Message
</code>

This renders to something like:

  2017-10-26 22:35:14 23277: Status Message

{{tag>bash logging}}