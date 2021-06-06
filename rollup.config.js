import dts from 'rollup-plugin-dts'
import esbuild from 'rollup-plugin-esbuild'
import { nodeResolve } from '@rollup/plugin-node-resolve';
import { terser } from 'rollup-plugin-terser';

const makeBundle = ({ input, output }) => {
  return [
    {
      input,
      plugins: [nodeResolve(), esbuild({
        minify: false,
      }), terser()],
      output: [
        {
          file: `${output}.js`,
          format: 'cjs',
          sourcemap: true,
        },
        {
          file: `${output}.mjs`,
          format: 'es',
          sourcemap: true,
        },
      ],
    },
    {
      input,
      plugins: [dts()],
      output: {
        file: `${output}.d.ts`,
        format: 'es',
      },
    }
  ]
}

export default [
  ...makeBundle({
    input: './src/Manager.ts',
    output: './dist/scrollock',
  }),
  ...makeBundle({
    input: './src/ReservedGapPlugin.ts',
    output: './plugins/reserved-gap-plugin',
  })
]