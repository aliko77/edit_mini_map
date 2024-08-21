## License
This project is licensed under the License - see the [LICENSE](LICENSE) file for details.

## Exports

```
---@param clipType 1 | 0 Map clip, 0 = rectangular, 1 = rounded
---@return table
const result = exports['edit_mini_map']:usePlacer(clipType)
-- > result: { offsetX = number, offsetY = number, scale = number }
```
