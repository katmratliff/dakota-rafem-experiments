#!/usr/bin/env python
from __future__ import print_function

import numpy as np

from heat_solver import BmiHeat


def main():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('infile', help='Name of input file')
    parser.add_argument('outfile', help='Name of output file')

    args = parser.parse_args()

    heat = BmiHeat()
    heat.initialize(args.infile)

    grid_id = heat.get_var_grid('plate_surface__temperature')
    grid_shape = heat.get_grid_shape(grid_id)

    temperature = np.zeros(grid_shape)
    temperature[grid_shape[0] / 2, grid_shape[1] / 2] = 1.

    heat.set_value('plate_surface__temperature', temperature)

    heat.update_until(100.)

    temperature = heat.get_value('plate_surface__temperature')

    with open(args.outfile, 'w') as fp:
        print('{max} max_temperature'.format(max=temperature.max()), file=fp)
        print('{mean} mean_temperature'.format(mean=temperature.mean()),
              file=fp)


if __name__ == '__main__':
    main()
