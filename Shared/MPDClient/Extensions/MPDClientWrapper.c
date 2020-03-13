//
//  MPDClientWrapper.c
//  Persephone
//
//  Created by Daniel Barber on 1/31/20.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

#include "MPDClientWrapper.h"

int
mpd_send_albumart(struct mpd_connection *connection, const char * uri, const char * offset)
{
  return mpd_send_command(connection, "albumart", uri, offset, NULL);
}
