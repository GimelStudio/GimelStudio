from sys import platform
if platform == "linux" or platform == "linux2":
    pass
elif platform == "darwin":
    import installer.createMacInstaller
elif platform == "win32":
    pass