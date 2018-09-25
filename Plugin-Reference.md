# Reference Plugins

FIXME The reference plugin is under development.  Nothing to see here yet.

The Reference Plugin(s) are generic plugins that implement key pieces of the
Plugin Architecture.

They are broken down into several separate plugins, each covering different
portions of the [Hook API Reference](Plugin-Hook-API-Ref.md)

## Standard Files

The following files should be included in every plugin

* README
* docs/CHANGELOG
* LICENSE
* setup.php
* index.php

```php
<?php

/*

 +-------------------------------------------------------------------------+

 | Copyright (C) 2004-2018 The Cacti Group                                 |

 |                                                                         |

 | This program is free software; you can redistribute it and/or           |

 | modify it under the terms of the GNU General Public License             |

 | as published by the Free Software Foundation; either version 2          |

 | of the License, or (at your option) any later version.                  |

 |                                                                         |

 | This program is distributed in the hope that it will be useful,         |

 | but WITHOUT ANY WARRANTY; without even the implied warranty of          |

 | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           |

 | GNU General Public License for more details.                            |

 +-------------------------------------------------------------------------+

 | Cacti: The Complete RRDTool-based Graphing Solution                     |

 +-------------------------------------------------------------------------+

 | This code is designed, written, and maintained by the Cacti Group. See  |

 | about.php and/or the AUTHORS file for specific developer information.   |

 +-------------------------------------------------------------------------+

 | https://www.cacti.net/                                                   |

 +-------------------------------------------------------------------------+

*/

header("Location:../index.php");

?>
```

## File Structure

All plugin files should reside under the plugin directory - in these examples 'ref_one'.

```markdown
ref_one/
    docs/
        CHANGELOG
    images/
        mylogo.png
    html/
    LICENSE
    README
    index.php
    setup.php
```
