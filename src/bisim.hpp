/**
 * Copyright Tom van Dijk
 */

#include <sylvan.h>
#include <oink/oink.hpp>
#include <symgame.hpp>

extern "C" {
    #include "simplehoa.h"
}

#pragma once

// Bisimulation minimisation

TASK(sylvan::MTBDD, min_lts_strong, SymGame*, sym, bool, strip_priority);
TASK(void, minimize, SymGame*, sym, sylvan::MTBDD, partition, bool, verbose);
TASK(void, print_partition, SymGame*, game, sylvan::MTBDD, partition);
TASK(void, print_signature, SymGame*, game, sylvan::MTBDD, signature);

size_t count_blocks();
