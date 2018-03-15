# retry until return code is 0
function retry
{
    $@
    while [ $? -ne 0 ]
    do
        sleep 1s # don't remove, or ctrl-c won't work
        $@
    done
}
