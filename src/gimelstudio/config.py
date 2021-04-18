

import gimelstudio.constants as appconst


class AppData(object):
    def __init__(self, app, cfgdir='~'):
        self.app_frozen = appconst.APP_FROZEN
        self.app_dir = appconst.APP_DIR
        self.app_name = appconst.APP_NAME
        self.app_website_url = appconst.APP_WEBSITE_URL
        self.app_description = appconst.APP_DESCRIPTION
        self.app_version = appconst.APP_VERSION
        self.app_version_tag = appconst.APP_VERSION_TAG
        self.app_version_full = appconst.APP_VERSION_FULL
