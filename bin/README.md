
## ConfigFile

You can edit the config file by the `dev` command. if you need help with the command type `dev -h` or `dev --help`, but by default the config file is this.

```ini
[Development]
path=D:\development
clear=true
```

Change config with this command:
```cmd
dev set <section> <key> <value>
```

where section is `Development` the key is `path` and value the value for the key.
