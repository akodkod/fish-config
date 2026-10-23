function cw --description 'Open the first VS Code workspace in the current folder'
    set -l workspaces ./*.code-workspace
    for workspace in $workspaces
        if test -f "$workspace"
            command code "$workspace" $argv
            return $status
        end
    end
    echo 'No .code-workspace file found in the current folder' >&2
    return 1
end
